pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property int dragThreshold: 30
    readonly property Sizes sizes: Sizes {}

    component Sizes: QtObject {
        readonly property int button: 80
    }
}
