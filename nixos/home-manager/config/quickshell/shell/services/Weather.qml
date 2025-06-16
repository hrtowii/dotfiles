pragma Singleton

import "root:/utils"
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string icon
    property string description
    property real temperature

    function reload(): void {
        wttrProc.running = true;
    }

    Process {
        id: wttrProc

        running: true
        command: ["fish", "-c", `curl "https://wttr.in/$(curl ipinfo.io | jq -r '.city' | string replace -a ' ' '%20')?format=j1" | jq -c '.current_condition[0] | {code: .weatherCode, desc: .weatherDesc[0].value, temp: .temp_C}'`]
        stdout: SplitParser {
            onRead: data => {
                const json = JSON.parse(data);
                root.icon = Icons.getWeatherIcon(json.code);
                root.description = json.desc;
                root.temperature = parseFloat(json.temp);
            }
        }
    }
}
