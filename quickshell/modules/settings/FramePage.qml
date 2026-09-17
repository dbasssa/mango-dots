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

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: Theme.bgcolor
            radius: States.itemRounding

            RowLayout {
                anchors.fill:parent
                anchors.margins: 10
                Text {
                    text: "Screen Frame: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }
                Text {
                    text: " toggle the frame around the monitor on/off"
                    color: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }
                Item{Layout.fillWidth: true}
                Switch {
                    checked: States.frameVis
                    onClicked: {
                        States.frameVis = checked
                        States.saveState("framevis", checked)
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
                    text: "Frame Rounding: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                TextField {
                    implicitHeight: 50
                    implicitWidth: 100
                    placeholderText: States.frameRounding
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
                            States.frameRounding = val
                            States.saveState("framerounding", val)
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
                    text: "Frame Thickness: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                TextField {
                    implicitHeight: 50
                    implicitWidth: 100
                    placeholderText: States.frameThickness
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
                            States.frameThickness = val
                            States.saveState("framethickness", val)
                        }
                    }

                }
            }
        }

    }
}