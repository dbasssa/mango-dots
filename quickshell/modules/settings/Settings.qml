import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules
import qs.modules.themeing

PanelWindow {
    id: root

    color: "transparent"
    visible: States.settingsOpen
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }

    IpcHandler {
        function toggle() {
            States.settingsOpen = !States.settingsOpen;
        }

        target: "settings-qs"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: States.settingsOpen = false
    }

    property int currentPage: 0

    Rectangle {
        anchors.centerIn: parent
        implicitHeight: 800
        implicitWidth: 1200
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

            RowLayout {
                spacing: 1
                Layout.fillHeight: true

                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: 70

                    color: Theme.rectcolor
                    radius: 12

                    border {
                        width: 1
                        color: Theme.bordercolor
                    }

                    ColumnLayout {
                        anchors.margins: 5
                        anchors.fill:parent
                        spacing: 5

                        Repeater {
                            model: ["Bar","Frame","Misc."]

                            delegate: Rectangle {
                                implicitHeight: 60
                                implicitWidth: 60

                                color: root.currentPage === model.index ? Theme.occupiedcolor : Theme.rectcolor
                                radius: 12

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.currentPage = model.index
                                }
                            }
                        }

                        Item{Layout.fillHeight: true}
                    }
                }
            }
        }

    }

}
