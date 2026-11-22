//@ pragma ShellId personal-launcher

import QtQuick
import Quickshell
import Quickshell.I3
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: launcher

    readonly property string query: search.text.trim().toLowerCase()
    readonly property bool showingCards: query.length === 0
    readonly property var apps: DesktopEntries.applications.values
        .filter(app => !app.noDisplay && app.name && app.command.length > 0)
        .sort((left, right) => left.name.localeCompare(right.name))
    readonly property var favorites: {
        const preferred = ["firefox", "discord", "org.telegram.desktop"];
        const entries = preferred.map(id => launcher.apps.find(app => app.id === id
            || app.id === id + ".desktop")).filter(app => app);
        return entries.concat(launcher.apps.filter(app => !entries.includes(app))).slice(0, 3);
    }
    readonly property var matches: {
        if (showingCards)
            return [];
        const terms = query.split(/\s+/);
        return apps.filter(app => {
            const searchable = [app.name, app.genericName, ...app.keywords].join(" ").toLowerCase();
            return terms.every(term => searchable.includes(term));
        });
    }
    readonly property var entries: showingCards ? favorites : matches
    property int selected: 0
    property bool presented: false

    screen: Quickshell.screens.find(output => I3.focusedMonitor
        && I3.monitorFor(output) === I3.focusedMonitor) ?? Quickshell.screens[0] ?? null
    implicitWidth: Math.min(640, Math.max(1, (screen?.width ?? 672) - 32))
    implicitHeight: Math.min(Math.max(1, (screen?.height ?? 640) - 32),
        showingCards ? 255 : 111 + Math.min(8, Math.max(1, matches.length)) * 44)
    color: "transparent"
    visible: presented
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "personal-launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: presented ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    BackgroundEffect.blurRegion: Region {
        item: panel
        radius: panel.radius
    }

    onQueryChanged: selected = 0
    onEntriesChanged: selected = Math.min(selected, Math.max(0, entries.length - 1))

    IpcHandler {
        target: "personalLauncher"

        function open(): void {
            launcher.showPanel();
        }

        function toggle(): void {
            if (launcher.presented)
                launcher.presented = false;
            else
                launcher.showPanel();
        }
    }

    function showPanel() {
        if (presented)
            return;
        search.clear();
        selected = 0;
        presented = true;
        search.forceActiveFocus();
    }

    function moveSelection(delta) {
        if (!entries.length)
            return;
        selected = (selected + delta + entries.length) % entries.length;
        if (!showingCards)
            results.positionViewAtIndex(selected, ListView.Contain);
    }

    function launch(app) {
        if (!app)
            return;
        if (app.runInTerminal) {
            Quickshell.execDetached({
                command: ["kitty", "-e", ...app.command],
                workingDirectory: app.workingDirectory
            });
        } else {
            app.execute();
        }
        presented = false;
    }

    Rectangle {
        id: panel
        anchors.fill: parent
        radius: 24
        border.color: "#427e6d99"
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: "#bd191425" }
            GradientStop { position: 0.7; color: "#b921192e" }
            GradientStop { position: 1; color: "#ae392945" }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 12

            Item {
                width: parent.width
                height: 38

                TextInput {
                    id: search
                    anchors.fill: parent
                    anchors.rightMargin: 36
                    verticalAlignment: TextInput.AlignVCenter
                    clip: true
                    color: "#fff6ff"
                    selectionColor: "#765590"
                    font.family: "Pond Gramercy"
                    font.pixelSize: 27
                    selectByMouse: true
                    focus: true

                    Keys.onEscapePressed: launcher.presented = false
                    Keys.onReturnPressed: launcher.launch(launcher.entries[launcher.selected])
                    Keys.onEnterPressed: launcher.launch(launcher.entries[launcher.selected])
                    Keys.onUpPressed: launcher.moveSelection(-1)
                    Keys.onDownPressed: launcher.moveSelection(1)
                    Keys.onLeftPressed: event => {
                        event.accepted = launcher.showingCards;
                        if (event.accepted)
                            launcher.moveSelection(-1);
                    }
                    Keys.onRightPressed: event => {
                        event.accepted = launcher.showingCards;
                        if (event.accepted)
                            launcher.moveSelection(1);
                    }
                }

                Text {
                    anchors.fill: search
                    verticalAlignment: Text.AlignVCenter
                    visible: search.text.length === 0
                    text: "Start typing to search"
                    color: "#a48fae"
                    font: search.font
                }

                Item {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 22
                    height: 22
                    Rectangle {
                        x: 5
                        width: 16
                        height: 16
                        radius: 8
                        color: "transparent"
                        border.width: 2
                        border.color: "#a48fae"
                    }
                    Rectangle {
                        x: 1
                        y: 16
                        width: 8
                        height: 2
                        rotation: -45
                        color: "#a48fae"
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#487e6d99"
            }

            Item {
                id: content
                width: parent.width
                height: Math.max(0, panel.height - 111)

                Row {
                    id: cards
                    anchors.fill: parent
                    visible: launcher.showingCards
                    spacing: 14

                    Repeater {
                        model: launcher.favorites

                        Rectangle {
                            id: card
                            required property var modelData
                            required property int index
                            width: (cards.width - cards.spacing * 2) / 3
                            height: cards.height
                            radius: 12
                            color: hover.hovered || index === launcher.selected ? "#327f6795" : "#147f6795"

                            IconImage {
                                x: 18
                                y: 18
                                implicitSize: 24
                                source: Quickshell.iconPath(card.modelData.icon, "application-x-executable")
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.margins: 18
                                elide: Text.ElideRight
                                text: card.modelData.name
                                color: "#e9d9ef"
                                font.family: search.font.family
                                font.pixelSize: 21
                            }

                            HoverHandler { id: hover }
                            TapHandler { onTapped: launcher.launch(card.modelData) }
                        }
                    }
                }

                ListView {
                    id: results
                    anchors.fill: parent
                    visible: !launcher.showingCards
                    clip: true
                    model: launcher.matches

                    delegate: Rectangle {
                        id: row
                        required property var modelData
                        required property int index
                        width: results.width
                        height: 44
                        radius: 8
                        color: rowHover.hovered || index === launcher.selected ? "#327f6795" : "transparent"

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 12

                            IconImage {
                                anchors.verticalCenter: parent.verticalCenter
                                implicitSize: 24
                                source: Quickshell.iconPath(row.modelData.icon, "application-x-executable")
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 36
                                elide: Text.ElideRight
                                text: row.modelData.name
                                color: "#fff6ff"
                                font.family: "Onest"
                                font.pixelSize: 15
                            }
                        }

                        HoverHandler { id: rowHover }
                        TapHandler { onTapped: launcher.launch(row.modelData) }
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: launcher.entries.length === 0
                    color: "#c6b6ce"
                    text: launcher.showingCards ? "No installed apps" : "No matching apps"
                }
            }
        }
    }
}
