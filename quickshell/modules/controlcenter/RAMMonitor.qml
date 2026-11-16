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

    FileView {
        id: memView

        path: "/proc/meminfo"
        preload: true

        onLoaded: {
            const text = memView.text().trim();
            const lines = text.split("\n");
            let ramTotalKb = 0;
            let ramAvailKb = 0;
            let ramFreeKb = 0;
            let ramBufKb = 0;
            let ramCachedKb = 0;
            for (let i = 0; i < lines.length; i++) {
                const line = lines[i];
                const sep = line.indexOf(":");
                if (sep < 0)
                    continue;
                const key = line.substring(0, sep).trim();
                const val = parseInt(line.substring(sep + 1).trim());
                if (key === "MemTotal")
                    ramTotalKb = val;
                else if (key === "MemAvailable")
                    ramAvailKb = val;
                else if (key === "MemFree")
                    ramFreeKb = val;
                else if (key === "Buffers")
                    ramBufKb = val;
                else if (key === "Cached")
                    ramCachedKb = val;
            }
            if (ramAvailKb <= 0)
                ramAvailKb = ramFreeKb + ramBufKb + ramCachedKb;
            const ramTotalMi = Math.round(ramTotalKb / 1024);
            const ramUsedMi = Math.round((ramTotalKb - ramAvailKb) / 1024);
            root.ramTotal = ramTotalMi;
            root.ramUsed = ramUsedMi;
        }
    }

    Timer {
        interval: 1000
        running: States.ctrlOpen
        repeat: true
        onTriggered: memView.reload();
    }

    ColumnLayout {
        spacing: 1
        anchors.fill: parent
        anchors.margins: 10

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
                    width: (parent.width - 4) * Math.max(0, Math.min(1, root.ramPercent / 100))
                    height: parent.height - 4
                    radius: States.tagRounding - 2
                    color: root.ramPercent > 80 ? Theme.alertcolor : Theme.miconcolor
                }

            }


    }

}
