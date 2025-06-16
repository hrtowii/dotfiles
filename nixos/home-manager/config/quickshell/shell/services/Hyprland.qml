pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    readonly property list<Client> clients: []
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors
    property Client activeClient: null
    readonly property HyprlandWorkspace activeWorkspace: focusedMonitor?.activeWorkspace ?? null
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    readonly property int activeWsId: activeWorkspace?.id ?? 1
    property point cursorPos

    function reload() {
        Hyprland.refreshWorkspaces();
        Hyprland.refreshMonitors();
        getClients.running = true;
        getActiveClient.running = true;
    }

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    Component.onCompleted: reload()

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (!event.name.endsWith("v2"))
                root.reload();
        }
    }

    Process {
        id: getClients
        command: ["sh", "-c", "hyprctl -j clients | jq -c"]
        stdout: SplitParser {
            onRead: data => {
                const clients = JSON.parse(data);
                const rClients = root.clients;

                const destroyed = rClients.filter(rc => !clients.find(c => c.address === rc.address));
                for (const client of destroyed)
                    rClients.splice(rClients.indexOf(client), 1).forEach(c => c.destroy());

                for (const client of clients) {
                    const match = rClients.find(c => c.address === client.address);
                    if (match) {
                        match.lastIpcObject = client;
                    } else {
                        rClients.push(clientComp.createObject(root, {
                            lastIpcObject: client
                        }));
                    }
                }
            }
        }
    }

    Process {
        id: getActiveClient
        command: ["hyprctl", "-j", "activewindow"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                const client = JSON.parse(data);
                const rClient = root.activeClient;
                if (client.address) {
                    if (rClient)
                        rClient.lastIpcObject = client;
                    else
                        root.activeClient = clientComp.createObject(root, {
                            lastIpcObject: client
                        });
                } else if (rClient) {
                    rClient.destroy();
                    root.activeClient = null;
                }
            }
        }
    }

    component Client: QtObject {
        required property var lastIpcObject
        readonly property string address: lastIpcObject.address
        readonly property string wmClass: lastIpcObject.class
        readonly property string title: lastIpcObject.title
        readonly property string initialClass: lastIpcObject.initialClass
        readonly property string initialTitle: lastIpcObject.initialTitle
        readonly property int x: lastIpcObject.at[0]
        readonly property int y: lastIpcObject.at[1]
        readonly property int width: lastIpcObject.size[0]
        readonly property int height: lastIpcObject.size[1]
        readonly property HyprlandWorkspace workspace: Hyprland.workspaces.values.find(w => w.id === lastIpcObject.workspace.id) ?? null
        readonly property bool floating: lastIpcObject.floating
        readonly property bool fullscreen: lastIpcObject.fullscreen
        readonly property int pid: lastIpcObject.pid
        readonly property int focusHistoryId: lastIpcObject.focusHistoryID
    }

    Component {
        id: clientComp

        Client {}
    }
}
