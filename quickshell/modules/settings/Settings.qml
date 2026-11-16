import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing

FloatingWindow {
    id: root

    //a regular floating (xdg-toplevel) window, managed by the compositor
    //instead of a full-screen layer shell panel
    title: "Settings"
    color: Theme.bgcolor
    visible: States.settingsOpen
    width: 1200
    height: 800
    minimumSize: Qt.size(900, 600)
    onClosed: States.settingsOpen = false

    IpcHandler {
        function toggle() {
            States.settingsOpen = !States.settingsOpen;
        }

        target: "settings-qs"
    }


    property int currentPage: 0

    Rectangle {
        anchors.fill: parent
        color: "transparent"

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
                implicitHeight: 50
                Layout.fillWidth: true
                color: Theme.rectcolor
                radius: States.itemRounding
                Text {
                    id: titleText

                    anchors.centerIn: parent
                    text: "Settings Customization"
                    color: Theme.text1

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                //close button — a floating window doesn't have the old
                //click-outside-to-close behaviour anymore
                Rectangle {
                    id: closeBtn

                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 28
                    implicitHeight: 28
                    radius: States.tagRounding
                    color: closeMouse.containsMouse ? Theme.recthovercolor : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: Theme.textmuted
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontlg
                        }
                    }

                    MouseArea {
                        id: closeMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: States.settingsOpen = false
                    }
                }
            }

            RowLayout {
                spacing: 5
                Layout.fillHeight: true

                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: 150

                    color: Theme.rectcolor
                    radius: States.itemRounding

                    ColumnLayout {
                        anchors.margins: 5
                        anchors.fill: parent
                        spacing: 5

                        Repeater {
                            model: ["Bar", "Frame", "Appearance", "Connections", "Timers"]

                            delegate: Rectangle {
                                implicitHeight: 40
                                implicitWidth: 140
                                anchors.margins: 10

                                color: root.currentPage === model.index ? Theme.occupiedcolor : Theme.rectcolor
                                radius: States.itemRounding

                                Text {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData
                                    color: Theme.text1
                                    font {
                                        family: Theme.fontfamily
                                        pixelSize: Theme.fontxl
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.currentPage = model.index
                                }
                            }
                        }

                        Item {
                            Layout.fillHeight: true
                        }
                    }
                }
                BarPage {
                    visible: root.currentPage === 0
                }
                FramePage {
                    visible: root.currentPage === 1
                }

                AppearancePage {
                    visible: root.currentPage === 2
                }
                ConnectionsPage {
                    visible: root.currentPage === 3
                }
                TimersPage {
                    visible: root.currentPage === 4
                }
            }
        }
    }
}
