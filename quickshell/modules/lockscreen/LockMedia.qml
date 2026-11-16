import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

import qs.modules
import qs.modules.themeing

//compact now-playing card for the lock screen
Rectangle {
    id: root

    readonly property var players: Mpris.players.values
    readonly property var player: {
        const list = root.players;
        if (!list || list.length === 0)
            return null;
        return list.find(p => p.isPlaying) ?? list[0];
    }

    visible: root.player !== null
    implicitHeight: 84
    radius: States.panelRounding
    color: Theme.rectcolor

    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        //album art (or a music note when the player has none)
        Rectangle {
            implicitWidth: 56
            implicitHeight: 56
            radius: 8
            color: Theme.recthovercolor
            clip: true

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            Image {
                id: art

                anchors.fill: parent
                asynchronous: true
                fillMode: Image.PreserveAspectCrop
                source: root.player && root.player.trackArtUrl ? root.player.trackArtUrl : ""
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                visible: art.status !== Image.Ready
                //md-music_note
                text: "\uDB80\uDF87"
                color: Theme.textmuted

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontxxl
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            spacing: 1

            ScrollingText {
                Layout.fillWidth: true
                text: root.player ? (root.player.trackTitle || "Unknown title") : ""
                color: Theme.text1
                pixelSize: Theme.fontlg
                bold: true
            }

            ScrollingText {
                Layout.fillWidth: true
                visible: root.player && root.player.trackArtist
                text: root.player ? root.player.trackArtist : ""
                color: Theme.textmuted
                pixelSize: Theme.fontmd
            }
        }

        RowLayout {
            spacing: 10

            Item {
                implicitWidth: 26
                implicitHeight: 26
                opacity: root.player && root.player.canGoPrevious ? 1 : 0.35

                Text {
                    anchors.centerIn: parent
                    text: "󰙣"
                    color: prevMouse.containsMouse ? Theme.text1 : Theme.textmuted

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }

                MouseArea {
                    id: prevMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: root.player && root.player.canGoPrevious
                    onClicked: root.player.previous()
                }
            }

            Item {
                implicitWidth: 30
                implicitHeight: 30
                opacity: root.player && root.player.canTogglePlaying ? 1 : 0.35

                Text {
                    anchors.centerIn: parent
                    text: root.player && root.player.isPlaying ? "" : ""
                    color: playMouse.containsMouse ? Theme.miconcolor : Theme.text1

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                MouseArea {
                    id: playMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: root.player && root.player.canTogglePlaying
                    onClicked: root.player.togglePlaying()
                }
            }

            Item {
                implicitWidth: 26
                implicitHeight: 26
                opacity: root.player && root.player.canGoNext ? 1 : 0.35

                Text {
                    anchors.centerIn: parent
                    text: "󰙡"
                    color: nextMouse.containsMouse ? Theme.text1 : Theme.textmuted

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }

                MouseArea {
                    id: nextMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: root.player && root.player.canGoNext
                    onClicked: root.player.next()
                }
            }
        }
    }
}
