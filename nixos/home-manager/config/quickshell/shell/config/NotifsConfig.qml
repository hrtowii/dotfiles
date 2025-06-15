pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property bool expire: false
    readonly property int defaultExpireTimeout: 3000
    readonly property real clearThreshold: 0.3
    readonly property int expandThreshold: 20
    readonly property bool actionOnClick: false
    readonly property Sizes sizes: Sizes {}

    component Sizes: QtObject {
        readonly property int width: 400
        readonly property int image: 41
        readonly property int badge: 20
    }
}
