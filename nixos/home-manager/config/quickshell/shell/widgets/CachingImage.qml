import "root:/services"
import QtQuick

Image {
    id: root

    property string path
    property bool loadOriginal
    readonly property Thumbnailer.Thumbnail thumbnail: Thumbnailer.go(this)

    source: thumbnail.path ? `file://${thumbnail.path}` : ""
    asynchronous: true
    fillMode: Image.PreserveAspectCrop
}
