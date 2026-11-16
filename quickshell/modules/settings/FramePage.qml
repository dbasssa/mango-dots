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

    function intError(t) {
        if (t == null) {
            return "";
        }
        var v = parseInt(t);
        if (t.trim() === "") {
            return "";
        }
        if (isNaN(v)) {
            return "Enter a whole number.";
        }
        if (v < 0) {
            return "Value can't be negative.";
        }
        return "";
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: Theme.bgcolor
            radius: States.itemRounding

            RowLayout {
                anchors.fill: parent
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
                Item {
                    Layout.fillWidth: true
                }
                ThemeSwitch {
                    checked: States.frameVis
                    onClicked: {
                        States.frameVis = checked;
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

                Text {
                    Layout.alignment: Qt.AlignVCenter
                    text: "Frame Rounding: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                TextField {
                    id: frameRoundField
                    implicitHeight: 50
                    implicitWidth: 100
                    placeholderText: States.frameRounding
                    placeholderTextColor: Theme.textmuted
                    font {
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
                        var val = parseInt(text);
                        if (!isNaN(val) && val >= 0) {
                            States.frameRounding = val;
                        }
                    }
                }
            }
        }

        Text {
            visible: intError(frameRoundField.text) !== ""
            text: intError(frameRoundField.text)
            color: Theme.alertcolor
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontsm
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

                Text {
                    Layout.alignment: Qt.AlignVCenter
                    text: "Frame Thickness: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                TextField {
                    id: frameThickField
                    implicitHeight: 50
                    implicitWidth: 100
                    placeholderText: States.frameThickness
                    placeholderTextColor: Theme.textmuted
                    font {
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
                        var val = parseInt(text);
                        if (!isNaN(val) && val >= 0) {
                            States.frameThickness = val;
                        }
                    }
                }
            }
        }

        Text {
            visible: intError(frameThickField.text) !== ""
            text: intError(frameThickField.text)
            color: Theme.alertcolor
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontsm
            }
        }
    }
}
