import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io


FloatingWindow {
    id: root

    minimumSize: Qt.size(800, 510)
    maximumSize: Qt.size(900, 600)
    visible: States.settingsOpen
    onClosed: States.settingsOpen = false

    IpcHandler {
        target: "settings-qs"
        function toggle() {
            States.settingsOpen = true
        }
    }

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

                RowLayout {
                    anchors.fill: parent
                    anchors.rightMargin: 12
                    anchors.leftMargin: 5
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: titleText.implicitWidth + 10
                        Text {
                            id: titleText

                            anchors.centerIn: parent
                            text: "Settings Customization (Only Bar Style changes.)"
                            color: Theme.text1

                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontxxl
                            }

                        }

                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        color: Theme.recthovercolor
                        implicitHeight: 20
                        implicitWidth: 20

                        Text {
                            anchors.centerIn: parent
                            text: "X"
                            color: Theme.text1
                        }

                        MouseArea {
                            anchors.fill:parent
                            onClicked: States.settingsOpen = false
                        }

                    }

                }

            }

            Flickable {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                contentHeight: column.implicitHeight
                clip: true
                boundsBehavior: Flickable.stopAtBounds

                ColumnLayout {
                    id: column

                    anchors.fill: parent
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 12
                    spacing: 2

                    Rectangle {
                        implicitHeight: 250
                        Layout.fillWidth: true
                        anchors.topMargin: 5
                        anchors.leftMargin: 5
                        Layout.alignment: Qt.AlignVCenter
                        color: Theme.rectcolor
                        radius: 12

                        border {
                            width: 2
                            color: Theme.bordercolor
                        }

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
                                spacing: 10

                                Item {
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    implicitHeight: 160
                                    implicitWidth: 150
                                    radius: 10
                                    color: Theme.rectcolor

                                    border {
                                        width: 3
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
                                            States.fullBar = true;
                                            States.islandBar = false;
                                            States.notchBar = false;
                                        }
                                    }

                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    implicitHeight: 160
                                    implicitWidth: 150
                                    radius: 10
                                    color: Theme.rectcolor

                                    border {
                                        width: 3
                                        color: Theme.bordercolor
                                    }

                                    Text {
                                        text: "Notch"
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
                                            States.fullBar = false;
                                            States.islandBar = false;
                                            States.notchBar = true;
                                        }
                                    }

                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    implicitHeight: 160
                                    implicitWidth: 150
                                    radius: 10
                                    color: Theme.rectcolor

                                    border {
                                        width: 3
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
                                            States.islandBar = true;
                                            States.fullBar = true;
                                            States.notchBar = false;
                                        }
                                    }

                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                            }

                        }

                    }

                    Rectangle {
                        implicitHeight: 200
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        color: Theme.rectcolor
                        radius: 12

                        border {
                            width: 2
                            color: Theme.bordercolor
                        }

                        ColumnLayout {
                            spacing: 2
                            anchors.fill: parent
                            anchors.topMargin: 5
                            anchors.bottomMargin: 12

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Frame Settings (Recommended only with Full Bar. Others will not look coherent)"
                                color: Theme.text1

                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontxl
                                    underline: true
                                }

                            }

                            Item {
                                Layout.fillHeight: true
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 20

                                Item {
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    implicitHeight: 150
                                    implicitWidth: 150
                                    color: Theme.occupiedcolor

                                    Text {
                                        anchors.centerIn: parent
                                        text: States.frameVis ? "On" : "Off"
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: States.frameVis = !States.frameVis
                                    }

                                }
                                ColumnLayout {
                                    spacing: 7
                                    Text {
                                        text: "Frame Thickness:"
                                        font {
                                            family: Theme.fontfamily
                                            pixelSize: fontxl
                                        }
                                        color: Theme.text1
                                    }

                                    Rectangle {
                                        implicitWidth: 150
                                        implicitHeight: 50
                                        color:"transparent"
                                        TextField {
                                            anchors.fill:parent
                                            placeholderText: States.frameThickness + "..."
                                            placeholderTextColor: Theme.activecolor
                                            background: Rectangle {
                                                anchors.fill: parent
                                                color: Theme.occupiedcolor
                                            }
                                            text: States.frameThickness.toString()
                                            onAccepted: { 
                                                var val = parseInt(text)
                                                if (!isNaN(val) && val >= 0) States.frameThickness = val
                                            }
                                        }
                                    }
                                    
                                }
                                ColumnLayout {
                                    spacing: 7
                                    Text {
                                        text: "Frame Rounding:"
                                        font {
                                            family: Theme.fontfamily
                                            pixelSize: fontxl
                                        }
                                        color: Theme.text1
                                    }

                                    Rectangle {
                                        implicitWidth: 150
                                        implicitHeight: 50
                                        color:"transparent"
                                        TextField {
                                            anchors.fill:parent
                                            placeholderText: States.frameRounding + "..."
                                            placeholderTextColor: Theme.activecolor
                                            background: Rectangle {
                                                anchors.fill: parent
                                                color: Theme.occupiedcolor
                                            }
                                            text: States.frameRounding.toString()
                                            onAccepted: { 
                                                var val = parseInt(text)
                                                if (!isNaN(val) && val >= 0) States.frameRounding = val
                                            }
                                        }
                                    }
                                    
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                            }

                            Item {
                                Layout.fillWidth: true
                            }

                        }

                    }

                    Rectangle {
                        implicitHeight: 200
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        color: Theme.rectcolor
                        radius: 12

                        border {
                            width: 2
                            color: Theme.bordercolor
                        }

                    }

                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn

                    contentItem: Rectangle {
                        implicitWidth: 4
                        radius: 2
                        color: parent.pressed ? Theme.textactive : Theme.textmuted
                    }

                }

            }

        }

    }

}
