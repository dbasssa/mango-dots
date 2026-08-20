import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets

Item {
    id: root

    readonly property var player: {
        const values = Mpris.players.values;
        values.length > 0 ? values[0] : null;
    }
    readonly property bool hasTitle: root.player && root.player.trackTitle
    readonly property url artUrl: root.player ? root.player.trackArtUrl : ""
    property bool artFailed: false

    implicitHeight: 100
    implicitWidth: 350
    anchors.horizontalCenter: parent.horizontalCenter

    ClippingRectangle {
        id: box

        anchors.fill: parent
        radius: 6
        color: Theme.rectcolor

        border {
            width: 2
            color: Theme.bordercolor
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
                color: Theme.textmuted
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
                        font.bold: root.player && root.player.isPlaying ? true : false
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
