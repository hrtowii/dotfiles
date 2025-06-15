pragma ComponentBehavior: Bound

import "root:/widgets"
import "root:/services"
import "root:/utils"
import "root:/config"
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root

    required property bool shouldUpdate
    required property PersistentProperties visibilities

    property real playerProgress: {
        const active = Players.active;
        return active?.length ? active.position / active.length : 0;
    }

    function lengthStr(length: int): string {
        if (length < 0)
            return "-1:-1";
        return `${Math.floor(length / 60)}:${Math.floor(length % 60).toString().padStart(2, "0")}`;
    }

    implicitWidth: cover.implicitWidth + DashboardConfig.sizes.mediaVisualiserSize * 2 + details.implicitWidth + details.anchors.leftMargin + bongocat.implicitWidth + bongocat.anchors.leftMargin * 2 + Appearance.padding.large * 2
    implicitHeight: Math.max(cover.implicitHeight + DashboardConfig.sizes.mediaVisualiserSize * 2, details.implicitHeight, bongocat.implicitHeight) + Appearance.padding.large * 2

    Behavior on playerProgress {
        NumberAnimation {
            duration: Appearance.anim.durations.large
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.standard
        }
    }

    Timer {
        running: root.shouldUpdate && (Players.active?.isPlaying ?? false)
        interval: DashboardConfig.mediaUpdateInterval
        triggeredOnStart: true
        repeat: true
        onTriggered: Players.active?.positionChanged()
    }

    Connections {
        target: Cava

        function onValuesChanged(): void {
            if (root.shouldUpdate)
                visualiser.requestPaint();
        }
    }

    Canvas {
        id: visualiser

        readonly property real centerX: width / 2
        readonly property real centerY: height / 2
        readonly property real innerX: cover.implicitWidth / 2 + Appearance.spacing.small
        readonly property real innerY: cover.implicitHeight / 2 + Appearance.spacing.small
        property color colour: Colours.palette.m3primary

        anchors.fill: cover
        anchors.margins: -DashboardConfig.sizes.mediaVisualiserSize

        onColourChanged: requestPaint()

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();

            const values = Cava.values;
            const len = values.length;

            ctx.strokeStyle = colour;
            ctx.lineWidth = 360 / len - Appearance.spacing.small / 4;
            ctx.lineCap = "round";

            const size = DashboardConfig.sizes.mediaVisualiserSize;
            const cx = centerX;
            const cy = centerY;
            const rx = innerX + ctx.lineWidth / 2;
            const ry = innerY + ctx.lineWidth / 2;

            for (let i = 0; i < len; i++) {
                const v = Math.max(1, Math.min(100, values[i]));

                const angle = i * 2 * Math.PI / len;
                const magnitude = v / 100 * size;
                const cos = Math.cos(angle);
                const sin = Math.sin(angle);

                ctx.moveTo(cx + rx * cos, cy + ry * sin);
                ctx.lineTo(cx + (rx + magnitude) * cos, cy + (ry + magnitude) * sin);
            }

            ctx.stroke();
        }

        Behavior on colour {
            ColorAnimation {
                duration: Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }
    }

    StyledClippingRect {
        id: cover

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Appearance.padding.large + DashboardConfig.sizes.mediaVisualiserSize

        implicitWidth: DashboardConfig.sizes.mediaCoverArtSize
        implicitHeight: DashboardConfig.sizes.mediaCoverArtSize

        color: Colours.palette.m3surfaceContainerHigh
        radius: Appearance.rounding.full

        MaterialIcon {
            anchors.centerIn: parent

            text: "art_track"
            color: Colours.palette.m3onSurfaceVariant
            font.pointSize: (parent.width * 0.4) || 1
        }

        Image {
            id: image

            anchors.fill: parent

            source: Players.active?.trackArtUrl ?? ""
            asynchronous: true
            fillMode: Image.PreserveAspectCrop
            sourceSize.width: width
            sourceSize.height: height
        }
    }

    Column {
        id: details

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: visualiser.right
        anchors.leftMargin: Appearance.spacing.normal

        spacing: Appearance.spacing.small

        StyledText {
            id: title

            anchors.horizontalCenter: parent.horizontalCenter

            animate: true
            horizontalAlignment: Text.AlignHCenter
            text: (Players.active?.trackTitle ?? qsTr("No media")) || qsTr("Unknown title")
            color: Colours.palette.m3primary
            font.pointSize: Appearance.font.size.normal

            width: parent.implicitWidth
            elide: Text.ElideRight
        }

        StyledText {
            id: album

            anchors.horizontalCenter: parent.horizontalCenter

            animate: true
            horizontalAlignment: Text.AlignHCenter
            text: (Players.active?.trackAlbum ?? qsTr("No media")) || qsTr("Unknown album")
            color: Colours.palette.m3outline
            font.pointSize: Appearance.font.size.small

            width: parent.implicitWidth
            elide: Text.ElideRight
        }

        StyledText {
            id: artist

            anchors.horizontalCenter: parent.horizontalCenter

            animate: true
            horizontalAlignment: Text.AlignHCenter
            text: (Players.active?.trackArtist ?? qsTr("No media")) || qsTr("Unknown artist")
            color: Colours.palette.m3secondary

            width: parent.implicitWidth
            elide: Text.ElideRight
        }

        Row {
            id: controls

            anchors.horizontalCenter: parent.horizontalCenter

            spacing: Appearance.spacing.small

            Control {
                icon: "skip_previous"
                canUse: Players.active?.canGoPrevious ?? false

                function onClicked(): void {
                    Players.active?.previous();
                }
            }

            Control {
                icon: Players.active?.isPlaying ? "pause" : "play_arrow"
                canUse: Players.active?.canTogglePlaying ?? false
                primary: true

                function onClicked(): void {
                    Players.active?.togglePlaying();
                }
            }

            Control {
                icon: "skip_next"
                canUse: Players.active?.canGoNext ?? false

                function onClicked(): void {
                    Players.active?.next();
                }
            }
        }

        Slider {
            id: slider

            implicitWidth: controls.implicitWidth * 1.5
            implicitHeight: Appearance.padding.normal * 3

            value: root.playerProgress
            onMoved: {
                const active = Players.active;
                if (active?.canSeek && active?.positionSupported)
                    active.position = value * active.length;
            }

            background: Item {
                StyledRect {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.topMargin: slider.implicitHeight / 3
                    anchors.bottomMargin: slider.implicitHeight / 3

                    implicitWidth: slider.handle.x - slider.implicitHeight / 6

                    color: Colours.palette.m3primary
                    radius: Appearance.rounding.full
                    topRightRadius: slider.implicitHeight / 15
                    bottomRightRadius: slider.implicitHeight / 15
                }

                StyledRect {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.topMargin: slider.implicitHeight / 3
                    anchors.bottomMargin: slider.implicitHeight / 3

                    implicitWidth: parent.width - slider.handle.x - slider.handle.implicitWidth - slider.implicitHeight / 6

                    color: Colours.palette.m3surfaceContainer
                    radius: Appearance.rounding.full
                    topLeftRadius: slider.implicitHeight / 15
                    bottomLeftRadius: slider.implicitHeight / 15
                }
            }

            handle: StyledRect {
                id: rect

                x: slider.visualPosition * slider.availableWidth

                implicitWidth: slider.implicitHeight / 4.5
                implicitHeight: slider.implicitHeight

                color: Colours.palette.m3primary
                radius: Appearance.rounding.full

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPressed: event => event.accepted = false
                }
            }
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right

            implicitHeight: Math.max(position.implicitHeight, length.implicitHeight)

            StyledText {
                id: position

                anchors.left: parent.left

                text: root.lengthStr(Players.active?.position ?? -1)
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                id: length

                anchors.right: parent.right

                text: root.lengthStr(Players.active?.length ?? -1)
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.small
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter

            spacing: Appearance.spacing.small

            Control {
                icon: "flip_to_front"
                canUse: Players.active?.canRaise ?? false
                fontSize: Appearance.font.size.larger
                padding: Appearance.padding.small
                fill: false
                color: Colours.palette.m3surfaceContainer

                function onClicked(): void {
                    Players.active?.raise();
                    root.visibilities.dashboard = false;
                }
            }

            MouseArea {
                id: playerSelector

                property bool expanded

                anchors.verticalCenter: parent.verticalCenter

                implicitWidth: slider.implicitWidth / 2
                implicitHeight: currentPlayer.implicitHeight + Appearance.padding.small * 2

                cursorShape: Qt.PointingHandCursor
                onClicked: expanded = !expanded

                RectangularShadow {
                    anchors.fill: playerSelectorBg

                    opacity: playerSelector.expanded ? 1 : 0
                    radius: playerSelectorBg.radius
                    color: Colours.palette.m3shadow
                    blur: 5
                    spread: 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Appearance.anim.durations.normal
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.anim.curves.standard
                        }
                    }
                }

                StyledRect {
                    id: playerSelectorBg

                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    implicitHeight: playersWrapper.implicitHeight + Appearance.padding.small * 2

                    color: Colours.palette.m3secondaryContainer
                    radius: Appearance.rounding.normal

                    Item {
                        id: playersWrapper

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: Appearance.padding.small

                        clip: true
                        implicitHeight: playerSelector.expanded && Players.list.length > 1 ? players.implicitHeight : currentPlayer.implicitHeight

                        Column {
                            id: players

                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom

                            spacing: Appearance.spacing.small

                            Repeater {
                                model: Players.list.filter(p => p !== Players.active)

                                Row {
                                    id: player

                                    required property MprisPlayer modelData

                                    anchors.horizontalCenter: parent.horizontalCenter
                                    spacing: Appearance.spacing.small

                                    IconImage {
                                        id: playerIcon

                                        source: Icons.getAppIcon(player.modelData.identity, "image-missing")
                                        implicitSize: Math.round(identity.implicitHeight * 0.9)
                                    }

                                    StyledText {
                                        id: identity

                                        text: identityMetrics.elidedText
                                        color: Colours.palette.m3onSecondaryContainer

                                        TextMetrics {
                                            id: identityMetrics

                                            text: player.modelData.identity
                                            font.family: identity.font.family
                                            font.pointSize: identity.font.pointSize
                                            elide: Text.ElideRight
                                            elideWidth: playerSelector.implicitWidth - playerIcon.implicitWidth - player.spacing - Appearance.padding.smaller * 2
                                        }

                                        MouseArea {

                                            anchors.fill: parent

                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                Players.manualActive = player.modelData;
                                                playerSelector.expanded = false;
                                            }
                                        }
                                    }
                                }
                            }

                            Item {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                implicitHeight: 1

                                StyledRect {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.margins: -Appearance.padding.normal
                                    color: Colours.palette.m3secondary
                                    implicitHeight: 1
                                }
                            }

                            Row {
                                id: currentPlayer

                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: Appearance.spacing.small

                                IconImage {
                                    id: currentIcon

                                    source: Icons.getAppIcon(Players.active?.identity ?? "", "multimedia-player")
                                    implicitSize: Math.round(currentIdentity.implicitHeight * 0.9)
                                }

                                StyledText {
                                    id: currentIdentity

                                    animate: true
                                    text: currentIdentityMetrics.elidedText
                                    color: Colours.palette.m3onSecondaryContainer

                                    TextMetrics {
                                        id: currentIdentityMetrics

                                        text: Players.active?.identity ?? "No players"
                                        font.family: currentIdentity.font.family
                                        font.pointSize: currentIdentity.font.pointSize
                                        elide: Text.ElideRight
                                        elideWidth: playerSelector.implicitWidth - currentIcon.implicitWidth - currentPlayer.spacing - Appearance.padding.smaller * 2
                                    }
                                }
                            }
                        }

                        Behavior on implicitHeight {
                            NumberAnimation {
                                duration: Appearance.anim.durations.normal
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Appearance.anim.curves.emphasized
                            }
                        }
                    }
                }
            }

            Control {
                icon: "delete"
                canUse: Players.active?.canQuit ?? false
                fontSize: Appearance.font.size.larger
                padding: Appearance.padding.small
                fill: false
                color: Colours.palette.m3surfaceContainer

                function onClicked(): void {
                    Players.active?.quit();
                }
            }
        }
    }

    Item {
        id: bongocat

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: details.right
        anchors.leftMargin: Appearance.spacing.normal

        implicitWidth: visualiser.width
        implicitHeight: visualiser.height

        AnimatedImage {
            anchors.centerIn: parent

            width: visualiser.width * 0.75
            height: visualiser.height * 0.75

            playing: root.shouldUpdate && (Players.active?.isPlaying ?? false)
            speed: BeatDetector.bpm / 300
            source: "root:/assets/bongocat.gif"
            asynchronous: true
            fillMode: AnimatedImage.PreserveAspectFit
        }
    }
    component Control: StyledRect {
        id: control

        required property string icon
        required property bool canUse
        property int fontSize: Appearance.font.size.extraLarge
        property int padding
        property bool fill: true
        property bool primary
        function onClicked(): void {
        }

        implicitWidth: Math.max(icon.implicitWidth, icon.implicitHeight) + padding * 2
        implicitHeight: implicitWidth

        radius: Appearance.rounding.full
        color: primary && canUse ? Colours.palette.m3primary : "transparent"

        StateLayer {
            disabled: !control.canUse
            radius: parent.radius
            color: control.primary ? Colours.palette.m3onPrimary : Colours.palette.m3onSurface

            function onClicked(): void {
                control.onClicked();
            }
        }

        MaterialIcon {
            id: icon

            anchors.centerIn: parent
            anchors.verticalCenterOffset: font.pointSize * 0.05

            animate: true
            fill: control.fill ? 1 : 0
            text: control.icon
            color: control.canUse ? control.primary ? Colours.palette.m3onPrimary : Colours.palette.m3onSurface : Colours.palette.m3outline
            font.pointSize: control.fontSize
        }
    }
}
