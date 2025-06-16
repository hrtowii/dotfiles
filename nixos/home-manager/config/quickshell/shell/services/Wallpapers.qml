pragma Singleton

import "root:/utils/scripts/fuzzysort.js" as Fuzzy
import "root:/utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string currentNamePath: `${Paths.state}/wallpaper/last.txt`.slice(7)
    readonly property string path: `${Paths.pictures}/Wallpapers`.slice(7)

    readonly property list<Wallpaper> list: wallpapers.instances
    property bool showPreview: false
    readonly property string current: showPreview ? previewPath : actualCurrent
    property string previewPath
    property string actualCurrent

    readonly property list<var> preppedWalls: list.map(w => ({
                name: Fuzzy.prepare(w.name),
                path: Fuzzy.prepare(w.path),
                wall: w
            }))

    function fuzzyQuery(search: string): var {
        return Fuzzy.go(search, preppedWalls, {
            all: true,
            keys: ["name", "path"],
            scoreFn: r => r[0].score * 0.9 + r[1].score * 0.1
        }).map(r => r.obj.wall);
    }

    function setWallpaper(path: string): void {
        actualCurrent = path;
        setWall.path = path;
        setWall.startDetached();
    }

    function preview(path: string): void {
        previewPath = path;
        showPreview = true;
        getPreviewColoursProc.running = true;
    }

    function stopPreview(): void {
        showPreview = false;
        Colours.endPreviewOnNextChange = true;
    }

    reloadableId: "wallpapers"

    FileView {
        path: root.currentNamePath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.actualCurrent = text().trim()
    }

    Process {
        id: getPreviewColoursProc

        command: ["caelestia", "scheme", "print", root.previewPath]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                Colours.load(data, true);
                Colours.showPreview = true;
            }
        }
    }

    Process {
        id: setWall

        property string path

        command: ["caelestia", "wallpaper", "-f", path]
    }

    Process {
        running: true
        command: ["fd", ".", root.path, "-t", "f", "-e", "jpg", "-e", "jpeg", "-e", "png", "-e", "svg"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => wallpapers.model = data.trim().split("\n")
        }
    }

    Variants {
        id: wallpapers

        Wallpaper {}
    }

    component Wallpaper: QtObject {
        required property string modelData
        readonly property string path: modelData
        readonly property string name: path.slice(path.lastIndexOf("/") + 1, path.lastIndexOf("."))
    }
}
