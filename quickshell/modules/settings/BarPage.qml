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
            currentIndex: States.notchBar ? 2 : (States.islandBar ? 1 : 0)
            onActivated: {
                if (index === 0) {
                    States.fullBarSelect()
                } else if (index === 1){
                    States.islandBarSelect()
                } else if (index === 2) {
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
            radius: States.itemRounding

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
                    checked: States.wsVisible
                    onClicked: States.wsVisible = checked
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: Theme.bgcolor
            radius: States.itemRounding
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
                    checked: States.appsVisible
                    onClicked: States.appsVisible = checked
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: Theme.bgcolor
            radius: States.itemRounding

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
                    checked: States.clockVisible
                    onClicked: States.clockVisible = checked
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: Theme.bgcolor
            radius: States.itemRounding

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
                    checked: States.buttonsVisible
                    onClicked: States.buttonsVisible = checked
                }
            }
        }

        Rectangle {
            implicitHeight: 70
            Layout.fillWidth: true
            color: Theme.bgcolor
            radius: States.itemRounding
            RowLayout {
                anchors.fill:parent
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

                Text {
                    Layout.alignment: Qt.AlignVCenter
                    text:"change the top-bottom length of the bar"
                    color: Theme.textmuted

                    font {
                        pixelSize: Theme.fontxl
                        family: Theme.fontfamily
                    }
                }

                Item {Layout.fillWidth: true}

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
                        radius: States.tagRounding

                    }

                    onAccepted: {
                        var val = parseInt(text) ?? null
                        if (val >= 0) {
                            States.barHeight = val
                            States.saveState("height", val)
                        }
                    }

                }
            }
        }

        Rectangle {
            implicitHeight: 70
            Layout.fillWidth: true
            color: Theme.bgcolor
            radius: States.itemRounding
            RowLayout {
                anchors.centerIn: parent
                spacing: 10

                Text{
                    Layout.alignment: Qt.AlignVCenter
                    text: "Bar Width: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                TextField {
                    implicitHeight: 50
                    implicitWidth: 100
                    placeholderText: States.barWidth
                    placeholderTextColor: Theme.textmuted
                    font{
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    } 
                    color: Theme.text1

                    background: Rectangle {
                        anchors.fill: parent
                        color: Theme.rectcolor
                        radius: States.tagRounding

                    }

                    onAccepted: {
                        var val = parseInt(text) ?? null
                        if (val >= 0) {
                            States.barWidth = val
                            States.saveState("width", val)
                        }
                    }

                }
            }
        }

        Rectangle {
            implicitHeight: 70
            Layout.fillWidth: true
            color: Theme.bgcolor
            radius: States.itemRounding
            RowLayout {
                anchors.centerIn: parent
                spacing: 10

                Text{
                    Layout.alignment: Qt.AlignVCenter
                    text: "Bar Rounding: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                TextField {
                    implicitHeight: 50
                    implicitWidth: 100
                    placeholderText: States.barRounding
                    placeholderTextColor: Theme.textmuted
                    font{
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    } 
                    color: Theme.text1

                    background: Rectangle {
                        anchors.fill: parent
                        color: Theme.rectcolor
                        radius: States.tagRounding

                    }

                    onAccepted: {
                        var val = parseInt(text) ?? null
                        if (val >= 0) {
                            States.barRounding = val
                            States.saveState("rounding", val)
                        }
                    }

                }
            }
        }

    }
}
