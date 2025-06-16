pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property int hideDelay: 2000
    readonly property Sizes sizes: Sizes {}

    component Sizes: QtObject {
        readonly property int sliderWidth: 30
        readonly property int sliderHeight: 150
    }
}
