import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing

Rectangle {
    id: root

    property int ramTotal: 0
    property int ramUsed: 0
    property int ramPercent: ramTotal > 0 ? (ramUsed / ramTotal * 100) : 0

    Layout.fillWidth: true
    implicitHeight: 100
    radius: States.panelRounding
    color: Theme.rectcolor

    border {
        width: 2
        color: Theme.bordercolor
    }

    Timer {
        interval: 1000
        running: true
        onTriggered: {
            if (!ramProc.running)
                ramProc.running = true;

        }
        repeat: true
    }

    Process {
        id: ramProc

        command: ["sh", "-c", "free -m | awk 'NR==2 {print $2, $3}'"]
        onExited: {
            var parts = stdout.text.trim().split(" ");
            root.ramTotal = parseInt(parts[0]);
            root.ramUsed = parseInt(parts[1]);
        }
        running: true

        stdout: StdioCollector {
        }

    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.bottomMargin: 10

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "RAM"
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
                bold: true
            }

        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Total Ram (MiBs): " + root.ramTotal
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }

        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "RAM Used (MiBs): " + root.ramUsed
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }

        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 10
                color: Theme.recthovercolor
                radius: States.tagRounding

                border {
                    width: 1
                    color: Theme.bordercolor
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 2
                    width: (parent.width - 4) * Math.max(0, Math.min(1, root.ramPercent / 100))
                    height: parent.height - 4
                    radius: States.tagRounding - 2
                    color: root.ramPercent > 80 ? "red" : "green"
                }

            }

            Text {
                text: root.ramPercent + "%"
                color: Theme.text1

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontlg
                }

            }

        }

    }

}
