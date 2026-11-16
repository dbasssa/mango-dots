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

    //cpu delta tracking for usage calculation
    property int cpuLastTotal: 0
    property int cpuLastIdle: 0

    Layout.fillWidth: true
    implicitHeight: 100
    radius: States.panelRounding
    color: Theme.rectcolor

    border {
        width: 2
        color: Theme.bordercolor
    }

    FileView {
        id: cpuStatView

        path: "/proc/stat"
        preload: true

        onLoaded: {
            const text = cpuStatView.text().trim();
            const lines = text.split("\n");
            let vals = null;
            for (let i = 0; i < lines.length; i++) {
                const line = lines[i].trim();
                if (line.startsWith("cpu")) {
                    const parts = line.split(/\s+/);
                    vals = [];
                    for (let j = 1; j < parts.length; j++) {
                        const n = parseInt(parts[j]);
                        vals.push(isNaN(n) ? 0 : n);
                    }
                    break;
                }
            }
            if (vals) {
                let sum = 0;
                for (let i = 0; i < vals.length; i++)
                    sum += vals[i];
                const idle = (vals[3] || 0) + (vals[4] || 0);

                let usage = 0;
                const dt = sum - root.cpuLastTotal;
                const di = idle - root.cpuLastIdle;
                if (dt > 0) {
                    const dIdle = di > 0 ? di : 0;
                    usage = ((dt - dIdle) / dt) * 100;
                }
                root.cpuUsage = Math.round(usage * 100) / 100;
                root.cpuLastTotal = sum;
                root.cpuLastIdle = idle;
            }
        }
    }

    FileView {
        id: cpuInfoView

        path: "/proc/cpuinfo"
        preload: true

        onLoaded: {
            const text = cpuInfoView.text().trim();
            const lines = text.split("\n");
            let name = "";
            let cores = 0;
            for (let i = 0; i < lines.length; i++) {
                const line = lines[i];
                if (line.startsWith("processor")) {
                    cores++;
                } else if (line.startsWith("model name") && name === "") {
                    name = line.split(":")[1].trim();
                }
            }
            root.cpuName = name.replace(/\s+\d+-Core Processor$/, "");
            root.cpuCores = cores;
        }
    }

    FileView {
        id: cpuTempView

        path: "/sys/class/hwmon/hwmon1/temp1_input"
        preload: true

        onLoaded: {
            const text = cpuTempView.text().trim();
            const t = parseInt(text);
            root.cpuTemp = String(Math.round(isNaN(t) ? 0 : t / 1000));
        }
    }

    Timer {
        interval: 1000
        running: States.ctrlOpen
        repeat: true
        onTriggered: {
            cpuStatView.reload();
            cpuInfoView.reload();
            cpuTempView.reload();
        }
    }

    ColumnLayout {
        spacing: 1
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
            implicitHeight: 10
            implicitWidth: 415
            color: Theme.recthovercolor
            radius: States.tagRounding

            border {
                width: 1
                color: Theme.bordercolor
            }

            Rectangle {
              anchors.centerIn: parent
                anchors.leftMargin: 2
                width: (parent.width - 4) * Math.max(0, Math.min(1, root.cpuUsage / 100))
                height: parent.height - 4
                radius: States.tagRounding - 2
                color: root.cpuUsage > 80 ? Theme.alertcolor : Theme.textactive
            }

        }

    }

}
