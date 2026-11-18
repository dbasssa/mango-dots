import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing
import qs.services

Rectangle {
    id: root

    Layout.fillHeight: true
    Layout.fillWidth: true
    color: Theme.bgcolor

    property string hostname: ""
    property string kernel: ""
    property string osName: ""
    property string uptimeText: ""
    property string cpuName: ""
    property string memoryText: ""
    property string sessionText: ""

    function formatUptime(seconds) {
        const s = Math.floor(seconds);
        if (!isFinite(s) || s < 0)
            return "";
        const d = Math.floor(s / 86400);
        const h = Math.floor((s % 86400) / 3600);
        const m = Math.floor((s % 3600) / 60);
        if (d > 0)
            return d + "d " + h + "h " + m + "m";
        if (h > 0)
            return h + "h " + m + "m";
        return m + "m";
    }

    function formatGiB(kb) {
        return (kb / 1024 / 1024).toFixed(1) + " GiB";
    }

    FileView {
        id: hostnameView

        path: "/proc/sys/kernel/hostname"
        preload: true
        onLoaded: root.hostname = hostnameView.text().trim()
    }

    FileView {
        id: kernelView

        path: "/proc/sys/kernel/osrelease"
        preload: true
        onLoaded: root.kernel = kernelView.text().trim()
    }

    FileView {
        id: osReleaseView

        path: "/etc/os-release"
        preload: true
        onLoaded: {
            const lines = osReleaseView.text().split("\n");
            for (let i = 0; i < lines.length; i++) {
                if (lines[i].startsWith("PRETTY_NAME=")) {
                    root.osName = lines[i].substring(12).replace(/^"|"$/g, "");
                    break;
                }
            }
        }
    }

    FileView {
        id: uptimeView

        path: "/proc/uptime"
        preload: true
        onLoaded: {
            const first = uptimeView.text().trim().split(/\s+/)[0];
            root.uptimeText = root.formatUptime(parseFloat(first));
        }
    }

    FileView {
        id: cpuInfoView

        path: "/proc/cpuinfo"
        preload: true
        onLoaded: {
            const lines = cpuInfoView.text().split("\n");
            for (let i = 0; i < lines.length; i++) {
                if (lines[i].startsWith("model name")) {
                    root.cpuName = lines[i].split(":")[1].trim();
                    break;
                }
            }
        }
    }

    FileView {
        id: memInfoView

        path: "/proc/meminfo"
        preload: true
        onLoaded: {
            const lines = memInfoView.text().split("\n");
            let total = 0;
            let avail = 0;
            for (let i = 0; i < lines.length; i++) {
                const sep = lines[i].indexOf(":");
                if (sep < 0)
                    continue;
                const key = lines[i].substring(0, sep).trim();
                const val = parseInt(lines[i].substring(sep + 1).trim());
                if (key === "MemTotal")
                    total = val;
                else if (key === "MemAvailable")
                    avail = val;
            }
            if (total > 0)
                root.memoryText = root.formatGiB(total - avail) + " / " + root.formatGiB(total);
        }
    }

    Process {
        id: sessionProc

        command: ["sh", "-c", "printf '%s / %s' \"${XDG_CURRENT_DESKTOP:-Unknown}\" \"${XDG_SESSION_TYPE:-wayland}\""]
        running: true
        stdout: StdioCollector {}

        onExited: root.sessionText = stdout.text.trim()
    }

    //uptime and memory change constantly; refresh them while the page is open
    Timer {
        interval: 5000
        running: root.visible
        repeat: true
        onTriggered: {
            uptimeView.reload();
            memInfoView.reload();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            text: "System"
            color: Theme.text1
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontxxl
                bold: true
            }
        }

        //system information
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: infoLayout.implicitHeight + 20
            radius: States.itemRounding
            color: Theme.bgcolor
            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            ColumnLayout {
                id: infoLayout

                anchors.fill: parent
                anchors.margins: 10
                spacing: 6

                Repeater {
                    model: [
                        {
                            label: "Hostname",
                            value: root.hostname
                        },
                        {
                            label: "Distribution",
                            value: root.osName
                        },
                        {
                            label: "Kernel",
                            value: root.kernel
                        },
                        {
                            label: "Uptime",
                            value: root.uptimeText
                        },
                        {
                            label: "CPU",
                            value: root.cpuName
                        },
                        {
                            label: "Memory",
                            value: root.memoryText
                        },
                        {
                            label: "Session",
                            value: root.sessionText
                        }
                    ]

                    delegate: RowLayout {
                        id: infoRow

                        required property var modelData

                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            Layout.preferredWidth: 150
                            text: infoRow.modelData.label
                            color: Theme.textmuted
                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontbase
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: infoRow.modelData.value
                            color: Theme.text1
                            elide: Text.ElideRight
                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontbase
                            }
                        }
                    }
                }
            }
        }

        //screenshot
        Rectangle {
            id: shotBtn

            Layout.fillWidth: true
            implicitHeight: 44
            radius: States.tagRounding
            color: shotMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            Text {
                anchors.centerIn: parent
                text: Screenshot.active ? "Select a region…" : "󰹑  Screenshot a region"
                color: Theme.text1
                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontmd
                }
            }

            MouseArea {
                id: shotMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Screenshot.region()
            }
        }

        Text {
            Layout.fillWidth: true
            visible: Screenshot.lastError !== "" || Screenshot.lastPath !== ""
            text: Screenshot.lastError !== "" ? Screenshot.lastError : "Saved: " + Screenshot.lastPath.split("/").pop()
            color: Screenshot.lastError !== "" ? Theme.alertcolor : Theme.textmuted
            elide: Text.ElideMiddle
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontsm
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
