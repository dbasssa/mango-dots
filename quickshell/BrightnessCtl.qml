import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    readonly property int bus: 4
    property int brightness: -1
    property int maxBrightness: 100
    readonly property bool ready: root.brightness >= 0
    readonly property bool on: root.ready && root.brightness >= Math.round(root.maxBrightness / 2)
    property bool busy: false
    property int pendingTarget: 0

    function startRead() {
        if (root.busy || reader.running)
            return;
        reader.command = ["ddcutil", "getvcp", "10", "--bus", String(root.bus), "--terse"];
        reader.running = true;
    }

    function toggle() {
        if (!root.ready || root.busy)
            return;
        root.pendingTarget = root.on ? 0 : root.maxBrightness;
        root.busy = true;
        setter.command = ["ddcutil", "setvcp", "10", String(root.pendingTarget), "--bus", String(root.bus)];
        setter.running = true;
    }

    implicitHeight: col.implicitHeight
    implicitWidth: parent.implicitWidth
    anchors.horizontalCenter: parent.horizontalCenter

    ColumnLayout {
        id: col
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: bbar
            Layout.preferredHeight: 50
            Layout.preferredWidth: 350
            radius: 5
            color: bMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
            Behavior on color { ColorAnimation { duration: 150 } }

            border {
                width: 2
                color: Theme.bordercolor
            }

            Rectangle {
                id: bFill
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                anchors.margins: 2
                width: (parent.width - 4) * (root.ready ? root.brightness / root.maxBrightness : 0)
                radius: 3
                color: root.on ? Theme.textactive : Theme.occupiedcolor
                Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Text {
                id: btxt
                anchors.centerIn: parent
                text: {
                    if (!root.ready)
                        return "Brightness";

                    return root.on ? " 100%" : " 0%";
                }
                color: root.ready ? (root.on ? Theme.text1 : Theme.textmuted) : Theme.textmuted
                font.family: Theme.fontfamily
                font.pixelSize: Theme.fontlg
                font.bold: true
                opacity: root.busy ? 0.6 : 1
                Behavior on opacity { NumberAnimation { duration: 150 } }
                Behavior on color { ColorAnimation { duration: 150 } }
                onTextChanged: btxtPop.restart()
            }

            SequentialAnimation {
                id: btxtPop
                NumberAnimation { target: btxt; property: "scale"; from: 0.94; to: 1.04; duration: 110; easing.type: Easing.OutCubic }
                NumberAnimation { target: btxt; property: "scale"; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
            }

            MouseArea {
                id: bMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.toggle()
            }

        }

    }

    Process {
        id: reader

        stdout: StdioCollector {}
        stderr: StdioCollector {}

        onExited: exitCode => {
            if (exitCode === 0) {
                const m = reader.stdout.text.match(/VCP\s+\S+\s+\S+\s+(\d+)\s+(\d+)/);
                if (m) {
                    root.maxBrightness = parseInt(m[2], 10);
                    root.brightness = parseInt(m[1], 10);
                }
            }
        }
    }

    Process {
        id: setter

        onExited: exitCode => {
            root.busy = false;
            if (exitCode === 0)
                root.brightness = root.pendingTarget;
            root.startRead();
        }
    }

    Timer {
        id: poll
        interval: 5000
        repeat: true
        running: States.ctrlOpen
        onTriggered: root.startRead()
        onRunningChanged: if (running) root.startRead()
    }

    Component.onCompleted: root.startRead()

}
