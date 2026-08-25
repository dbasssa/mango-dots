import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

FloatingWindow {
    id: root
    minimumSize: Qt.size(800,510)
    maximumSize: Qt.size(900,600)
    visible: States.settingsOpen

    Rectangle {
        anchors.fill: parent
        color: Theme.bgcolor
        radius: 20

        ColumnLayout {
            //alignment code
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            anchors.bottomMargin: 8
            spacing: 5

            Rectangle {
                id: titleRect
                Layout.alignment: Qt.AlignVCenter
                anchors.top: parent.top
                implicitHeight: 50
                Layout.fillWidth: true
                color: Theme.rectcolor
                radius: 12

                border {
                    width: 2
                    color: Theme.bordercolor
                }

                Text {
                    anchors.centerIn: parent
                    text: "Settings Customization (Only Bar Style changes.)"
                    color: Theme.text1

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }

                }

            }

            Flickable {
                Layout.alignment: Qt.AlignVCenter
                width: 780
                height: 440
                contentHeight: column.implicitHeight
                clip: true
                boundsBehavior: Flickable.stopAtBounds

                ColumnLayout {
                    id: column
                    anchors.fill:parent
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 12
                    spacing: 2

                    Rectangle {
                        implicitHeight: 250
                        implicitWidth: 770
                        anchors.topMargin: 5
                        anchors.leftMargin: 5
                        Layout.alignment: Qt.AlignVCenter
                        color: Theme.rectcolor

                        border {
                            width: 2
                            color: Theme.bordercolor
                        }
                        radius: 12

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.bottomMargin: 10
                            anchors.topMargin: 5
                            spacing: 2

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Bar Style"
                                color: Theme.text1
                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontxl
                                    underline: true
                                }
                            }

                            RowLayout {
                                Item { Layout.fillWidth: true}
                                spacing: 10
                                Rectangle {
                                    implicitHeight: 160
                                    implicitWidth: 150
                                    radius: 10
                                    color: Theme.rectcolor
                                    border {
                                        width:3
                                        color: Theme.bordercolor
                                    }
                                    Text {
                                        text: "Full Bar"
                                        anchors.centerIn: parent
                                        color: Theme.text1
                                        font {
                                            family: Theme.fontfamily
                                            pixelSize: Theme.fontxxl
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            States.fullBar = true
                                            States.islandBar = false
                                        }
                                    }
                                }
                                Item { Layout.fillWidth: true}
                                Rectangle {
                                    implicitHeight: 160
                                    implicitWidth: 150
                                    radius: 10
                                    color: Theme.rectcolor
                                    border {
                                        width:3
                                        color: Theme.bordercolor
                                    }
                                    Text {
                                        text: "Pill"
                                        anchors.centerIn: parent
                                        color: Theme.text1
                                        font {
                                            family: Theme.fontfamily
                                            pixelSize: Theme.fontxxl
                                        }
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            States.fullBar = false
                                            States.islandBar = false
                                        }
                                    }
                                }
                                Item { Layout.fillWidth: true}
                                Rectangle {
                                    implicitHeight: 160
                                    implicitWidth: 150
                                    radius: 10
                                    color: Theme.rectcolor
                                    border {
                                        width:3
                                        color: Theme.bordercolor
                                    }
                                    Text {
                                        text: "Island"
                                        anchors.centerIn: parent
                                        color: Theme.text1
                                        font {
                                            family: Theme.fontfamily
                                            pixelSize: Theme.fontxxl
                                        }
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            States.islandBar = true
                                            States.fullBar = true
                                        }
                                    }
                                }
                                Item {Layout.fillWidth: true}
                            }
                        }

                    }
                    Rectangle {
                        implicitHeight: 200
                        implicitWidth: 770
                        Layout.alignment: Qt.AlignVCenter
                        color: Theme.rectcolor

                        border {
                            width: 2
                            color: Theme.bordercolor
                        }
                        radius: 12

                        ColumnLayout {
                            spacing: 2
                            anchors.fill: parent
                            anchors.topMargin: 5
                            anchors.bottomMargin: 12
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Frame Settings"
                                color: Theme.text1
                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontxl
                                    underline: true
                                }
                            }
                            Item {Layout.fillHeight: true}
                            RowLayout {
                                Layout.fillWidth: true
                                Item{ Layout.fillWidth: true}
                                Rectangle {
                                    implicitHeight: 150
                                    implicitWidth: 150
                                    color: Theme.occupiedcolor

                                    Text {
                                        anchors.centerIn: parent
                                        text: States.frameVis ? "On" : "Off"
                                    }
                                }
                                Item { Layout.fillWidth: true}
                            }
                            Item { Layout.fillWidth: true}

                        }

                    }
                    Rectangle {
                        implicitHeight: 200
                        implicitWidth: 770
                        Layout.alignment: Qt.AlignVCenter
                        color: Theme.rectcolor

                        border {
                            width: 2
                            color: Theme.bordercolor
                        }
                        radius: 12

                    }                    

                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    contentItem: Rectangle {
                        implicitWidth: 4
                        radius: 2
                        color: parent.pressed ? Theme.textactive : Theme.textmuted
                    }
                    background: Rectangle {
                        color: Theme.rectcolor
                        radius: 2

                    }
                }

            }

        }

    }

}
