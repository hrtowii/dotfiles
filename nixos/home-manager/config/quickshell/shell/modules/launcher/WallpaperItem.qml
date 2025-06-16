import "root:/widgets"
import "root:/services"
import "root:/config"
import Quickshell
import QtQuick
import QtQuick.Effects

StyledRect {
    id: root

    required property Wallpapers.Wallpaper modelData
    required property PersistentProperties visibilities

    scale: 0.5
    opacity: 0
    z: PathView.z ?? 0

    Component.onCompleted: {
        scale = Qt.binding(() => PathView.isCurrentItem ? 1 : PathView.onPath ? 0.8 : 0);
        opacity = Qt.binding(() => PathView.onPath ? 1 : 0);
    }

    implicitWidth: image.width + Appearance.padding.larger * 2
    implicitHeight: image.height + label.height + Appearance.spacing.small / 2 + Appearance.padding.large + Appearance.padding.normal

    StateLayer {
        radius: Appearance.rounding.normal

        function onClicked(): void {
            Wallpapers.setWallpaper(root.modelData.path);
            root.visibilities.launcher = false;
        }
    }

    CachingImage {
        id: image

        anchors.horizontalCenter: parent.horizontalCenter
        y: Appearance.padding.large

        visible: false
        path: root.modelData.path
        smooth: !root.PathView.view.moving

        width: LauncherConfig.sizes.wallpaperWidth
        height: width / 16 * 9
    }

    Rectangle {
        id: mask

        layer.enabled: true
        layer.smooth: true
        visible: false
        anchors.fill: image
        radius: Appearance.rounding.normal
    }

    RectangularShadow {
        opacity: root.PathView.isCurrentItem ? 0.7 : 0
        anchors.fill: mask
        radius: mask.radius
        color: Colours.palette.m3shadow
        blur: 10
        spread: 3

        Behavior on opacity {
            Anim {}
        }
    }

    MultiEffect {
        anchors.fill: image
        source: image
        maskEnabled: true
        maskSource: mask
        maskSpreadAtMin: 1
        maskThresholdMin: 0.5
    }

    StyledText {
        id: label

        anchors.top: image.bottom
        anchors.topMargin: Appearance.spacing.small / 2
        anchors.horizontalCenter: parent.horizontalCenter

        width: image.width - Appearance.padding.normal * 2
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        renderType: Text.QtRendering
        text: root.modelData.name
        font.pointSize: Appearance.font.size.normal
    }

    Behavior on scale {
        Anim {}
    }

    Behavior on opacity {
        Anim {}
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
