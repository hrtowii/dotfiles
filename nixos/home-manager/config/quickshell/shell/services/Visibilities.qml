pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    property var screens: ({})
    property var panels: ({})

    function getForActive(): PersistentProperties {
        return Object.entries(screens).find(s => s[0].slice(s[0].indexOf('"') + 1, s[0].lastIndexOf('"')) === Hyprland.focusedMonitor.name)[1];
    }

    IpcHandler {
        target: "drawers"

        function show(drawer: string): string {
            const vis = getForActive();
            if (!vis) return "No active screen found";
            
            if (drawer === "launcher") vis.launcher = true;
            else if (drawer === "session") vis.session = true;
            else if (drawer === "dashboard") vis.dashboard = true;
            else if (drawer === "osd") vis.osd = true;
            else return "Invalid drawer name";
            
            return `Showing ${drawer}`;
        }

        function toggle(drawer: string): string {
            const vis = getForActive();
            if (!vis) return "No active screen found";
            
            if (drawer === "launcher") vis.launcher = !vis.launcher;
            else if (drawer === "session") vis.session = !vis.session;
            else if (drawer === "dashboard") vis.dashboard = !vis.dashboard;
            else if (drawer === "osd") vis.osd = !vis.osd;
            else return "Invalid drawer name";
            
            return `Toggled ${drawer} to ${vis[drawer]}`;
        }
    }
}
