pragma ComponentBehavior: Bound

import "root:/widgets"
import "root:/services"
import "root:/config"
import "root:/modules/bar"
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

Variants {
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData

        Exclusions {
            screen: scope.modelData
            bar: bar
        }

        StyledWindow {
            id: win

            screen: scope.modelData
            name: "drawers"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: visibilities.launcher || visibilities.session ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

            mask: Region {
                x: bar.implicitWidth
                y: BorderConfig.thickness
                width: win.width - bar.implicitWidth - BorderConfig.thickness
                height: win.height - BorderConfig.thickness * 2
                intersection: Intersection.Xor

                regions: regions.instances
            }

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Variants {
                id: regions

                model: panels.children

                Region {
                    required property Item modelData

                    x: modelData.x + bar.implicitWidth
                    y: modelData.y + BorderConfig.thickness
                    width: modelData.width
                    height: modelData.height
                    intersection: Intersection.Subtract
                }
            }

            HyprlandFocusGrab {
                active: visibilities.launcher || visibilities.session
                windows: [win]
                onCleared: {
                    visibilities.launcher = false;
                    visibilities.session = false;
                }
            }

            StyledRect {
                anchors.fill: parent
                opacity: visibilities.session ? 0.5 : 0
                color: Colours.palette.m3scrim

                Behavior on opacity {
                    NumberAnimation {
                        duration: Appearance.anim.durations.normal
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.anim.curves.standard
                    }
                }
            }

            Item {
                id: background

                anchors.fill: parent
                visible: false

                Border {
                    bar: bar
                }

                Backgrounds {
                    panels: panels
                    bar: bar
                }
            }

            LayerShadow {
                source: background
            }

            PersistentProperties {
                id: visibilities

                property bool osd
                property bool session
                property bool launcher
                property bool dashboard

                Component.onCompleted: Visibilities.screens[scope.modelData] = this
            }

            Interactions {
                screen: scope.modelData
                popouts: panels.popouts
                visibilities: visibilities
                panels: panels
                bar: bar

                Panels {
                    id: panels

                    screen: scope.modelData
                    visibilities: visibilities
                    bar: bar
                }
            }

            Bar {
                id: bar

                screen: scope.modelData
                popouts: panels.popouts
            }
        }
    }
}
