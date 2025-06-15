pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property list<AccessPoint> networks: []
    readonly property AccessPoint active: networks.find(n => n.active) ?? null

    reloadableId: "network"

    Process {
        running: true
        command: ["nmcli", "m"]
        stdout: SplitParser {
            onRead: getNetworks.running = true
        }
    }

    Process {
        id: getNetworks
        running: true
        command: ["sh", "-c", `nmcli -g ACTIVE,SIGNAL,FREQ,SSID d w | jq -cR '[(inputs / ":") | select(.[3] | length >= 4)]'`]
        stdout: SplitParser {
            onRead: data => {
                const networks = JSON.parse(data).map(n => [n[0] === "yes", parseInt(n[1]), parseInt(n[2]), n[3]]);
                const rNetworks = root.networks;

                const destroyed = rNetworks.filter(rn => !networks.find(n => n[2] === rn.frequency && n[3] === rn.ssid));
                for (const network of destroyed)
                    rNetworks.splice(rNetworks.indexOf(network), 1).forEach(n => n.destroy());

                for (const network of networks) {
                    const match = rNetworks.find(n => n.frequency === network[2] && n.ssid === network[3]);
                    if (match) {
                        match.active = network[0];
                        match.strength = network[1];
                        match.frequency = network[2];
                        match.ssid = network[3];
                    } else {
                        rNetworks.push(apComp.createObject(root, {
                            active: network[0],
                            strength: network[1],
                            frequency: network[2],
                            ssid: network[3]
                        }));
                    }
                }
            }
        }
    }

    component AccessPoint: QtObject {
        required property string ssid
        required property int strength
        required property int frequency
        required property bool active
    }

    Component {
        id: apComp

        AccessPoint {}
    }
}
