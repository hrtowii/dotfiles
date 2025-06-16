pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool powered
    property bool discovering
    readonly property list<Device> devices: []

    Process {
        running: true
        command: ["bluetoothctl"]
        stdout: SplitParser {
            onRead: {
                getInfo.running = true;
                getDevices.running = true;
            }
        }
    }

    Process {
        id: getInfo
        running: true
        command: ["sh", "-c", "bluetoothctl show | paste -s"]
        stdout: SplitParser {
            onRead: data => {
                root.powered = data.includes("Powered: yes");
                root.discovering = data.includes("Discovering: yes");
            }
        }
    }

    Process {
        id: getDevices
        running: true
        command: ["fish", "-c", `for a in (bluetoothctl devices | cut -d ' ' -f 2); bluetoothctl info $a | jq -R 'reduce (inputs / ":") as [$key, $value] ({}; .[$key | ltrimstr("\t")] = ($value | ltrimstr(" ")))' | jq -c --arg addr $a '.Address = $addr'; end | jq -sc`]
        stdout: SplitParser {
            onRead: data => {
                const devices = JSON.parse(data).filter(d => d.Name);
                const rDevices = root.devices;

                const destroyed = rDevices.filter(rd => !devices.find(d => d.Address === rd.address));
                for (const device of destroyed)
                    rDevices.splice(rDevices.indexOf(device), 1).forEach(d => d.destroy());

                for (const device of devices) {
                    const match = rDevices.find(d => d.address === device.Address);
                    if (match) {
                        match.lastIpcObject = device;
                    } else {
                        rDevices.push(deviceComp.createObject(root, {
                            lastIpcObject: device
                        }));
                    }
                }
            }
        }
    }

    component Device: QtObject {
        required property var lastIpcObject
        readonly property string name: lastIpcObject.Name
        readonly property string alias: lastIpcObject.Alias
        readonly property string address: lastIpcObject.Address
        readonly property string icon: lastIpcObject.Icon
        readonly property bool connected: lastIpcObject.Connected === "yes"
        readonly property bool paired: lastIpcObject.Paired === "yes"
        readonly property bool trusted: lastIpcObject.Trusted === "yes"
    }

    Component {
        id: deviceComp

        Device {}
    }
}
