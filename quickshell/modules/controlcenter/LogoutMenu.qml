import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing

//session actions for the control center. power actions need a second click so
//a stray click can't log the session out or power the machine off.
ColumnLayout {
    id: root

    Layout.fillWidth: true
    spacing: 6

    //action waiting for confirmation, empty when nothing is pending
    property string pending: ""

    readonly property var actions: [
        {
            id: "logout",
            label: "Log out",
            icon: "󰗽"
        },
        {
            id: "hibernate",
            label: "Hibernate",
            icon: "󰒲"
        },
        {
            id: "reboot",
            label: "Reboot",
            icon: ""
        },
        {
            id: "shutdown",
            label: "Shut down",
            icon: "󰐥"
        }
    ]

    function commandFor(id) {
        if (id === "logout")
            return ["pkill", "-TERM", "-x", "mango"];
        if (id === "hibernate")
            return ["systemctl", "hibernate"];
        if (id === "reboot")
            return ["systemctl", "reboot"];
        if (id === "shutdown")
            return ["systemctl", "poweroff"];
        return [];
    }

    function runAction(id) {
        const cmd = root.commandFor(id);
        if (cmd.length === 0)
            return;
        actionProc.command = cmd;
        actionProc.running = true;
    }

    function requestAction(id) {
        if (root.pending === id) {
            root.pending = "";
            root.runAction(id);
        } else {
            root.pending = id;
            confirmTimer.restart();
        }
    }

    Timer {
        id: confirmTimer

        interval: 5000
        onTriggered: root.pending = ""
    }

    Process {
        id: actionProc

        command: []
        running: false
    }

    Repeater {
        model: root.actions

        delegate: Rectangle {
            id: actionRow

            required property var modelData

            readonly property bool confirming: root.pending === actionRow.modelData.id

            Layout.fillWidth: true
            implicitHeight: 30
            radius: States.tagRounding
            color: actionRow.confirming ? Theme.occupiedcolor : (actionMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor)

            border {
                width: States.borderOn ? 1 : 0
                color: actionRow.confirming ? Theme.alertcolor : Theme.bordercolor
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 8

                Text {
                    text: actionRow.modelData.icon
                    color: actionRow.confirming ? Theme.alertcolor : Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontbase
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: actionRow.confirming ? "Click again to confirm" : actionRow.modelData.label
                    color: actionRow.confirming ? Theme.alertcolor : Theme.text1
                    elide: Text.ElideRight
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontbase
                    }
                }
            }

            MouseArea {
                id: actionMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.requestAction(actionRow.modelData.id)
            }
        }
    }

    Text {
        Layout.fillWidth: true
        Layout.topMargin: 2
        text: "Power actions ask for a second click and reset after 5 seconds."
        color: Theme.textmuted
        wrapMode: Text.WordWrap
        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontsm
        }
    }
}
