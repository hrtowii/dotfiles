pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property int maxShown: 8
    readonly property int maxWallpapers: 9 // Warning: even numbers look bad
    readonly property string actionPrefix: ">"
    readonly property Sizes sizes: Sizes {}

    component Sizes: QtObject {
        readonly property int itemWidth: 600
        readonly property int itemHeight: 57
        readonly property int wallpaperWidth: 280
        readonly property int wallpaperHeight: 200
    }
}
