import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing

Rectangle {
    id: root

    property int cpuCores: 0
    property string cpuName: ""
    property string cpuTemp: ""
    property real cpuUsage: 0

    Layout.fillWidth: true
    implicitHeight: 100
    radius: States.panelRounding
    color: Theme.rectcolor

    border {
        width: 2
        color: Theme.bordercolor
    }

    Process {
        id: cpuProc

        command: ["bash", Quickshell.shellDir + "/scripts/cpustats.sh"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                const line = String(data).trim();
                if (line === "")
                    return ;

                let obj = null;
                try {
                    obj = JSON.parse(line);
                } catch (e) {
                    console.log("CPUPARSE FAIL: ", e, line);
                    return ;
                }
                if (obj) {
                    if (obj.name !== undefined)
                        root.cpuName = obj.name;

                    if (obj.cores !== undefined)
                        root.cpuCores = parseInt(obj.cores);

                    if (obj.usage !== undefined)
                        root.cpuUsage = parseFloat(obj.usage);

                    if (obj.temp !== undefined)
                        root.cpuTemp = obj.temp;

                }
            }
        }

    }

    ColumnLayout {
        spacing: 10
        anchors.fill: parent
        anchors.margins: 10

        RowLayout {
            spacing: 20

            ColumnLayout {
                spacing: 10

                Text {
                    text: root.cpuName
                    color: Theme.text1

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontlg
                    }

                }

                Text {
                    text: root.cpuCores + " Cores Available"
                    color: Theme.text1

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontlg
                    }

                }

            }

            ColumnLayout {
                spacing: 10

                Text {
                    text: "CPU Temprature: " + root.cpuTemp
                    color: Theme.text1

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontlg
                    }

                }

                Text {
                    text: "CPU Load: " + root.cpuUsage + "%"
                    color: Theme.text1

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontlg
                    }

                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 10
            Layout.alignment: Qt.AlignHCenter
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
                width: (parent.width - 4) * Math.max(0, Math.min(1, root.cpuUsage / 100))
                height: parent.height - 4
                radius: States.tagRounding - 2
                color: root.cpuUsage > 80 ? "red" : "green"
            }

        }

    }

}
