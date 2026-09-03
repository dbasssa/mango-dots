import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets

import qs.modules.themeing

Item {
    id: root

    property int playerIndex: 0
    readonly property var playersList: Mpris.players.values

    readonly property var player: root.playersList.length > 0 ? root.playersList[Math.min(root.playerIndex, root.playersList.length - 1)] : null
    readonly property bool hasTitle: root.player && root.player.trackTitle
    readonly property bool hasArtist: root.player && root.player.trackArtist
    readonly property url artUrl: root.player ? root.player.trackArtUrl : ""
    property bool artFailed: false

    implicitHeight: 100
    Layout.fillWidth: true
    anchors.horizontalCenter: parent.horizontalCenter

    MouseArea {
        anchors.fill: parent
        z: -1
        onWheel: {
            if (root.playersList.length <= 1)
                return;
            root.playerIndex = (root.playerIndex + (wheel.angleDelta.y > 0 ? 1 : root.playersList.length - 1)) % root.playersList.length;
        }
    }

    ClippingRectangle {
        id: box

        anchors.fill: parent
        radius: 6
        color: Theme.rectcolor

        border {
            width: 2
            color: Theme.bordercolor
        }

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            width: 6
            radius: 3
            color: "transparent"
            z: 10

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5

                Repeater {
                    model: root.playersList

                    Rectangle {
                        width: 6
                        height: 16
                        radius: 2
                        color: index === root.playerIndex ? Theme.textactive : "transparent"
                        border.color: index === root.playerIndex ? Theme.textactive : Theme.textmuted
                        border.width: 2
                        opacity: index === root.playerIndex ? 1 : 0.6

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }

                        }

                        Behavior on border.color {
                            ColorAnimation {
                                duration: 150
                            }

                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                            }

                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (index >= 0 && index < root.playersList.length)
                                    root.playerIndex = index;
                            }
                        }

                    }

                }

            }

        }

        Image {
            id: art

            anchors.fill: parent
            source: root.artUrl != "" && !root.artFailed ? root.artUrl : ""
            fillMode: Image.PreserveAspectCrop
            visible: source != ""
            smooth: true
            opacity: 0
            onSourceChanged: art.opacity = 0
            onStatusChanged: {
                if (status === Image.Ready)
                    art.opacity = 1;
                else if (status === Image.Error)
                    root.artFailed = true;
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.OutCubic
                }

            }

        }

        Rectangle {
            anchors.fill: parent
            color: Theme.bgcolor
            opacity: 0.72
            visible: art.visible
        }

        ColumnLayout {
            anchors.centerIn: parent
            anchors.leftMargin: root.hasTitle ? 8 : 5
            spacing: 1

            Text {
                id: title
                anchors.horizontalCenter: parent.horizontalCenter
                Layout.fillWidth: true
                Layout.maximumWidth: implicitWidth
                visible: root.hasTitle
                text: root.player ? root.player.trackTitle : ""
                color: Theme.text1
                font.family: Theme.fontfamily
                font.pixelSize: Theme.fontxl
                font.bold: true
                elide: Text.ElideRight
                onTextChanged: titleFade.restart()

                transform: Translate {
                    id: titleT

                    y: 0
                }

            }

            Text {
                id: artist
                anchors.horizontalCenter: parent.horizontalCenter
                Layout.fillWidth: true
                Layout.maximumWidth: implicitWidth
                visible: root.hasArtist
                text: root.player ? root.player.trackArtist : ""
                color: Theme.text1
                font.family: Theme.fontfamily
                font.pixelSize: Theme.fontmd
                font.bold: true
                elide: Text.ElideRight
                onTextChanged: titleFade.restart()

                transform: Translate {
                    id: artistT

                    y: 0
                }

            }

            ParallelAnimation {
                id: titleFade

                NumberAnimation {
                    target: title
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 280
                    easing.type: Easing.OutCubic
                }

                NumberAnimation {
                    target: titleT
                    property: "y"
                    from: 6
                    to: 0
                    duration: 320
                    easing.type: Easing.OutCubic
                }

            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                spacing: 50
                anchors.leftMargin: 50
                anchors.rightMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    Layout.preferredWidth: 12
                    Layout.fillHeight: true
                    color: "transparent"

                    Text {
                        id: prevIcon

                        anchors.centerIn: parent
                        text: "󰙣"
                        color: prevMouse.containsMouse ? Theme.textactive : Theme.text1
                        font.family: Theme.fontfamily
                        font.pixelSize: Theme.fontxxl
                        scale: prevMouse.pressed ? 0.8 : (prevMouse.containsMouse ? 1.25 : 1)

                        Behavior on scale {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutBack
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }

                        }

                    }

                    MouseArea {
                        id: prevMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        enabled: root.player && root.player.canGoPrevious
                        onClicked: {
                            if (root.player)
                                root.player.previous();

                        }
                    }

                }

                Rectangle {
                    Layout.preferredWidth: 15
                    Layout.fillHeight: true
                    color: "transparent"

                    Text {
                        id: playIcon

                        anchors.centerIn: parent
                        text: ""
                        color: (playMouse.containsMouse || (root.player && root.player.isPlaying)) ? Theme.textactive : Theme.text1
                        font.family: Theme.fontfamily
                        font.pixelSize: root.player && root.player.isPlaying ? Theme.fontxl : Theme.fontlg
                        scale: playMouse.pressed ? 0.8 : (playMouse.containsMouse ? 1.25 : 1)

                        Behavior on scale {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutBack
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }

                        }

                    }

                    MouseArea {
                        id: playMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        enabled: root.player && root.player.canTogglePlaying
                        onClicked: {
                            if (root.player)
                                root.player.togglePlaying();

                        }
                    }

                }

                Rectangle {
                    Layout.preferredWidth: 12
                    Layout.fillHeight: true
                    color: "transparent"

                    Text {
                        id: nextIcon

                        anchors.centerIn: parent
                        text: "󰙡"
                        color: nextMouse.containsMouse ? Theme.textactive : Theme.text1
                        font.family: Theme.fontfamily
                        font.pixelSize: Theme.fontxxl
                        scale: nextMouse.pressed ? 0.8 : (nextMouse.containsMouse ? 1.25 : 1)

                        Behavior on scale {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutBack
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }

                        }

                    }

                    MouseArea {
                        id: nextMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        enabled: root.player && root.player.canGoNext
                        onClicked: {
                            if (root.player)
                                root.player.next();

                        }
                    }

                }

            }

        }

    }

}
