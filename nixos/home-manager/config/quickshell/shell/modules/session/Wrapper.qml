import "root:/services"
import "root:/config"
import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities

    visible: width > 0
    implicitWidth: 0
    implicitHeight: content.implicitHeight

    states: State {
        name: "visible"
        when: root.visibilities.session

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
                duration: root.visibilities.osd ? Appearance.anim.durations.expressiveFastSpatial : Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.visibilities.osd ? Appearance.anim.curves.expressiveFastSpatial : Appearance.anim.curves.emphasized
            }
        }
    ]

    Content {
        id: content

        visibilities: root.visibilities
    }
}
