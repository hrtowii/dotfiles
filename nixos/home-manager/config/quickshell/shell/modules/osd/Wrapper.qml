import "root:/services"
import "root:/config"
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property bool visibility

    visible: width > 0
    implicitWidth: 0
    implicitHeight: content.implicitHeight

    states: State {
        name: "visible"
        when: root.visibility

        PropertyChanges {
            root.implicitWidth: content.implicitWidth
        }
    }

    transitions: [
        Transition {
            from: ""
            to: "visible"

            NumberAnimation {
                target: root
                property: "implicitWidth"
                duration: Appearance.anim.durations.expressiveFastSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
            }
        },
        Transition {
            from: "visible"
            to: ""

            NumberAnimation {
                target: root
                property: "implicitWidth"
                duration: Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.emphasized
            }
        }
    ]

    Content {
        id: content

        monitor: Brightness.getMonitorForScreen(root.screen)
    }
}
