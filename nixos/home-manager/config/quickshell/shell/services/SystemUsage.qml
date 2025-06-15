pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real cpuPerc
    property real cpuTemp
    property real gpuPerc
    property real gpuTemp
    property int memUsed
    property int memTotal
    readonly property real memPerc: memTotal > 0 ? memUsed / memTotal : 0
    property int storageUsed
    property int storageTotal
    property real storagePerc: storageTotal > 0 ? storageUsed / storageTotal : 0

    property int lastCpuIdle
    property int lastCpuTotal

    function formatKib(kib: int): var {
        const mib = 1024;
        const gib = 1024 ** 2;
        const tib = 1024 ** 3;

        if (kib >= tib)
            return {
                value: kib / tib,
                unit: "TiB"
            };
        if (kib >= gib)
            return {
                value: kib / gib,
                unit: "GiB"
            };
        if (kib >= mib)
            return {
                value: kib / mib,
                unit: "MiB"
            };
        return {
            value: kib,
            unit: "KiB"
        };
    }

    Timer {
        running: true
        interval: 3000
        repeat: true
        onTriggered: {
            stat.reload();
            meminfo.reload();
            storage.running = true;
            cpuTemp.running = true;
            gpuUsage.running = true;
            gpuTemp.running = true;
        }
    }

    FileView {
        id: stat

        path: "/proc/stat"
        onLoaded: {
            const data = text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (data) {
                const stats = data.slice(1).map(n => parseInt(n, 10));
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3];

                const totalDiff = total - root.lastCpuTotal;
                const idleDiff = idle - root.lastCpuIdle;
                root.cpuPerc = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;

                root.lastCpuTotal = total;
                root.lastCpuIdle = idle;
            }
        }
    }

    FileView {
        id: meminfo

        path: "/proc/meminfo"
        onLoaded: {
            const data = text();
            root.memTotal = parseInt(data.match(/MemTotal: *(\d+)/)[1], 10) || 1;
            root.memUsed = (root.memTotal - parseInt(data.match(/MemAvailable: *(\d+)/)[1], 10)) || 0;
        }
    }

    Process {
        id: storage

        running: true
        command: ["sh", "-c", "df | grep '^/dev/' | awk '{print $3, $4}'"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                let used = 0;
                let avail = 0;
                for (const line of data.trim().split("\n")) {
                    const [u, a] = line.split(" ");
                    used += parseInt(u, 10);
                    avail += parseInt(a, 10);
                }
                root.storageUsed = used;
                root.storageTotal = used + avail;
            }
        }
    }

    Process {
        id: cpuTemp

        running: true
        command: ["fish", "-c", "cat /sys/class/thermal/thermal_zone*/temp | string join ' '"]
        stdout: SplitParser {
            onRead: data => {
                const temps = data.trim().split(" ");
                const sum = temps.reduce((acc, d) => acc + parseInt(d, 10), 0);
                root.cpuTemp = sum / temps.length / 1000;
            }
        }
    }

    Process {
        id: gpuUsage

        running: true
        command: ["sh", "-c", "cat /sys/class/drm/card*/device/gpu_busy_percent"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                const percs = data.trim().split("\n");
                const sum = percs.reduce((acc, d) => acc + parseInt(d, 10), 0);
                root.gpuPerc = sum / percs.length / 100;
            }
        }
    }

    Process {
        id: gpuTemp

        running: true
        command: ["sh", "-c", "sensors | jq -nRc '[inputs]'"]
        stdout: SplitParser {
            onRead: data => {
                let eligible = false;
                let sum = 0;
                let count = 0;
                for (const line of JSON.parse(data)) {
                    if (line === "Adapter: PCI adapter")
                        eligible = true;
                    else if (line === "")
                        eligible = false;
                    else if (eligible) {
                        const match = line.match(/^(temp[0-9]+|GPU core|edge)+:\s+\+([0-9]+\.[0-9]+)°C/);
                        if (match) {
                            sum += parseFloat(match[2]);
                            count++;
                        }
                    }
                }
                root.gpuTemp = count > 0 ? sum / count : 0;
            }
        }
    }
}
