import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules
import qs.modules.themeing
import qs.services

Rectangle {
    id: root

    Layout.fillHeight: true
    Layout.fillWidth: true
    color: Theme.bgcolor

    //action waiting for a second click, empty when nothing is pending
    property string pending: ""

    readonly property var actions: [
        {
            id: "lock",
            label: "Lock screen",
            icon: "󰌾",
            needsConfirm: false
        },
        {
            id: "suspend",
            label: "Suspend",
            icon: "󰒲",
            needsConfirm: true
        },
        {
            id: "logout",
            label: "Log out",
            icon: "󰗽",
            needsConfirm: true
        },
        {
            id: "reboot",
            label: "Reboot",
            icon: "",
            needsConfirm: true
        },
        {
            id: "shutdown",
            label: "Shut down",
            icon: "󰐥",
            needsConfirm: true
        }
    ]

    Timer {
        id: pendingTimer

        interval: 5000
        onTriggered: root.pending = ""
    }

    function runAction(id) {
        if (id === "lock")
            States.lockScreen = true;
        else if (id === "suspend")
            suspendProc.running = true;
        else if (id === "logout")
            logoutProc.running = true;
        else if (id === "reboot")
            rebootProc.running = true;
        else if (id === "shutdown")
            shutdownProc.running = true;
    }

    function requestAction(id) {
        if (id === "lock") {
            root.runAction(id);
            return;
        }
        if (root.pending === id) {
            root.pending = "";
            root.runAction(id);
        } else {
            root.pending = id;
            pendingTimer.restart();
        }
    }

    Process {
        id: suspendProc

        command: ["systemctl", "suspend"]
        running: false
    }

    Process {
        id: logoutProc

        command: ["pkill", "-TERM", "-x", "mango"]
        running: false
    }

    Process {
        id: rebootProc

        command: ["systemctl", "reboot"]
        running: false
    }

    Process {
        id: shutdownProc

        command: ["systemctl", "poweroff"]
        running: false
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            text: "Power"
            color: Theme.text1
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontxxl
                bold: true
            }
        }

        //battery (laptops only)
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            visible: Battery.exists
            radius: States.itemRounding
            color: Theme.bgcolor
            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: Battery.get_Battery_Icon()
                    color: Battery.percentage < 20 && !Battery.isCharging ? Theme.alertcolor : Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "Battery"
                        color: Theme.text1
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxxl
                        }
                    }
                    Text {
                        text: Battery.percentage + "% · " + (Battery.isCharging ? "Charging" : "Discharging")
                        color: Theme.textmuted
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontsm
                        }
                    }
                }
            }
        }

        Text {
            Layout.topMargin: 4
            text: "Session"
            color: Theme.text1
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
                bold: true
            }
        }

        Repeater {
            model: root.actions

            delegate: Rectangle {
                id: actionRow

                required property var modelData

                Layout.fillWidth: true
                implicitHeight: 44
                radius: States.tagRounding
                color: root.pending === actionRow.modelData.id ? Theme.occupiedcolor : (actionMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor)

                border {
                    width: States.borderOn ? 1 : 0
                    color: root.pending === actionRow.modelData.id ? Theme.alertcolor : Theme.bordercolor
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Text {
                        text: actionRow.modelData.icon
                        color: root.pending === actionRow.modelData.id ? Theme.alertcolor : Theme.text1
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxl
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.pending === actionRow.modelData.id ? "Click again to confirm" : actionRow.modelData.label
                        color: root.pending === actionRow.modelData.id ? Theme.alertcolor : Theme.text1
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
            text: "Destructive actions ask for a second click and reset after 5 seconds."
            color: Theme.textmuted
            wrapMode: Text.WordWrap
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
