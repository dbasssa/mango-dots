import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.modules
import qs.modules.themeing

Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: Theme.bgcolor
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        ComboBox {
            id: barBox
            Layout.alignment: Qt.AlignHCenter
            width: 200
            height: 50
            model: ["Full Bar","Island Bar", "Notch"]
            onCurrentIndexChanged: {
                if (currentIndex === 0) {
                    States.fullBarSelect()
                } else if (currentIndex === 1){
                    States.islandBarSelect()
                } else if (currentIndex === 2) {
                    States.notchSelect()
                }
            }
            background: Rectangle {
                implicitWidth: 200
                color: Theme.rectcolor
            }
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: Theme.bgcolor
            radius: 12

            border {
                width: 4
                color: Theme.bordercolor
            }
            RowLayout {
                anchors.fill:parent
                anchors.margins: 10
                Text {
                    text: "Tag Module: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }
                Text {
                    text: " toggle the workspaces module on/off"
                    color: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }
                Item{Layout.fillWidth: true}
                Switch {
                    checked: States.wsVisible = true
                    onClicked: States.wsVisible = checked
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: Theme.bgcolor
            radius: 12

            border {
                width: 4
                color: Theme.bordercolor
            }
            RowLayout {
                anchors.fill:parent
                anchors.margins: 10
                Text {
                    text: "App Name Module: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }
                Text {
                    text: " toggle the app name module on/off"
                    color: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }
                Item{Layout.fillWidth: true}
                Switch {
                    checked: States.appsVisible = true
                    onClicked: States.appsVisible = checked
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: Theme.bgcolor
            radius: 12

            border {
                width: 4
                color: Theme.bordercolor
            }
            RowLayout { // dk why you would want no clock but sure
                anchors.fill:parent
                anchors.margins: 10
                Text {
                    text: "Clock Module: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }
                Text {
                    text: " toggle the clock module on/off"
                    color: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }
                Item{Layout.fillWidth: true}
                Switch {
                    checked: States.clockVisible = true
                    onClicked: States.clockVisible = checked
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: Theme.bgcolor
            radius: 12

            border {
                width: 4
                color: Theme.bordercolor
            }
            RowLayout { // dk why you would want no clock but sure
                anchors.fill:parent
                anchors.margins: 10
                Text {
                    text: "Buttons: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }
                Text {
                    text: " toggle the settings and notification button on/off"
                    color: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }
                Item{Layout.fillWidth: true}
                Switch {
                    checked: States.buttonsVisible = true
                    onClicked: States.buttonsVisible = checked
                }
            }
        }

        Rectangle {
            implicitHeight: 70
            Layout.fillWidth: true
            color: Theme.bgcolor
            radius: 12
            border {
                width: 4
                color: Theme.bordercolor
            }
            RowLayout {
                anchors.centerIn: parent
                spacing: 10

                Text{
                    Layout.alignment: Qt.AlignVCenter
                    text: "Bar Height: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                TextField {
                    implicitHeight: 50
                    implicitWidth: 100
                    placeholderText: States.barHeight
                    placeholderTextColor: Theme.textmuted
                    font{
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    } 
                    color: Theme.text1

                    background: Rectangle {
                        anchors.fill: parent
                        color: Theme.rectcolor
                        radius: 10

                    }

                    onAccepted: {
                        var val = parseInt(text) ?? null
                        if (val >= 0) {
                            States.barHeight = val
                        }
                    }

                }
            }
        }

    }
}
