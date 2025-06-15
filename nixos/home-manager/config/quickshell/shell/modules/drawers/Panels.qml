import "root:/services"
import "root:/config"
import "root:/modules/osd" as Osd
import "root:/modules/notifications" as Notifications
import "root:/modules/session" as Session
import "root:/modules/launcher" as Launcher
import "root:/modules/dashboard" as Dashboard
import "root:/modules/bar/popouts" as BarPopouts
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property Item bar

    readonly property Osd.Wrapper osd: osd
    readonly property Notifications.Wrapper notifications: notifications
    readonly property Session.Wrapper session: session
    readonly property Launcher.Wrapper launcher: launcher
    readonly property Dashboard.Wrapper dashboard: dashboard
    readonly property BarPopouts.Wrapper popouts: popouts

    anchors.fill: parent
    anchors.margins: BorderConfig.thickness
    anchors.leftMargin: bar.implicitWidth

    Component.onCompleted: Visibilities.panels[screen] = this

    Osd.Wrapper {
        id: osd

        clip: root.visibilities.session
        screen: root.screen
        visibility: root.visibilities.osd

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: session.width
    }

    Notifications.Wrapper {
        id: notifications

        anchors.top: parent.top
        anchors.right: parent.right
    }

    Session.Wrapper {
        id: session

        visibilities: root.visibilities

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
    }

    Launcher.Wrapper {
        id: launcher

        visibilities: root.visibilities

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

    Dashboard.Wrapper {
        id: dashboard

        visibilities: root.visibilities

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }

    BarPopouts.Wrapper {
        id: popouts

        screen: root.screen

        anchors.left: parent.left
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: {
            const off = root.popouts.currentCenter - BorderConfig.thickness;
            const diff = root.height - Math.floor(off + implicitHeight / 2);
            if (diff < 0)
                return off + diff;
            return off;
        }
    }
}
