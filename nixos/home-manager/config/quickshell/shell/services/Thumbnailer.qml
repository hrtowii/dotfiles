pragma Singleton
pragma ComponentBehavior: Bound

import "root:/utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string thumbDir: `${Paths.cache}/thumbnails`.slice(7)

    function go(obj: var): var {
        return thumbComp.createObject(obj, {
            originalPath: obj.path,
            width: obj.width,
            height: obj.height,
            loadOriginal: obj.loadOriginal
        });
    }

    component Thumbnail: QtObject {
        id: obj

        required property string originalPath
        required property int width
        required property int height
        required property bool loadOriginal

        property string path

        readonly property Process proc: Process {
            running: true
            command: ["fish", "-c", `
set -l path "${root.thumbDir}/$(sha1sum ${obj.originalPath} | cut -d ' ' -f 1)@${obj.width}x${obj.height}-exact.png"
if test -f $path
    echo $path
else
    echo 'start'
    set -l size (identify -ping -format '%w\n%h' ${obj.originalPath})
    if test $size[1] -gt ${obj.width} -o $size[2] -gt ${obj.height}
        magick ${obj.originalPath} -${obj.width > 1024 || obj.height > 1024 ? "resize" : "thumbnail"} ${obj.width}x${obj.height}^ -background none -gravity center -extent ${obj.width}x${obj.height} -unsharp 0x.5 $path
    else
        cp ${obj.originalPath} $path
    end
    echo $path
end`]
            stdout: SplitParser {
                onRead: data => {
                    if (data === "start") {
                        if (obj.loadOriginal)
                            obj.path = obj.originalPath;
                    } else {
                        obj.path = data;
                    }
                }
            }
        }

        function reload(): void {
            proc.signal(9);
            proc.running = true;
        }
    }

    Component {
        id: thumbComp

        Thumbnail {}
    }
}
