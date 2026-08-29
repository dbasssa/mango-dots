import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property int ramTotal: 0
    property int ramUsed: 0
    property int ramPercent: ramTotal > 0 ? (ramUsed / ramTotal * 100) : 0

    Layout.fillWidth: true
    implicitHeight: 100
    radius: 20
    color: Theme.rectcolor

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

    border {
        width: 2
        color: Theme.bordercolor
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.bottomMargin: 10

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "RAM Monitor"
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
                bold: true
                underline: true
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
            Layout.alignment: Qt.AlignHCenter

            Rectangle {
                implicitWidth: 500
                implicitHeight: 10
                Layout.alignment: Qt.AlignHCenter
                color: Theme.recthovercolor
                radius: 10

                border {
                    width: 1
                    color: Theme.bordercolor
                }

                Rectangle {
                    anchors.left: parent.left
                    implicitHeight: 9
                    implicitWidth: parent.implicitWidth * (root.ramPercent / 100)
                    radius: 10
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
