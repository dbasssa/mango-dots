import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.modules
import qs.modules.themeing
Scope {
    id: root

    IpcHandler {
        function toggle() {
            States.statsOpen = !States.statsOpen;
        }

        target: "systemmonitor-qs"
    }

    PanelWindow {
        id: monitorPanel

        visible: States.statsOpen
        implicitHeight: 400
        implicitWidth: 700
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            right: true
            left: true
            bottom: true

        }

        margins {
            top: States.barHeight + States.frameThickness + 5
        }
        MouseArea {
            anchors.fill: parent
            onClicked: States.statsOpen = !States.statsOpen
        }

        Rectangle {
            implicitHeight: 400
            implicitWidth: 700
            color: Theme.bgcolor
            radius: 20
            anchors.centerIn: parent
            border {
                width: 2
                color: Theme.bordercolor
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 5
                anchors.leftMargin: 10
                anchors.rightMargin: 10


                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "System Monitor"
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                        underline: true
                    }

                }

                RAMMonitor {
                }

                CPUMonitor {}
                

            }

        }

    }

}
