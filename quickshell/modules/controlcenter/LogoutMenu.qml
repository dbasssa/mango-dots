import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing

ColumnLayout {
    id: root

    Layout.fillWidth: true
    anchors.margins: 10

    Process {
        id: logoutProc

        command: ["pkill", "-TERM", "-x", "mango"]
    }

    Process {
        id: shutdownProc

        command: ["sh", "-c", "systemctl poweroff"]
    }

    Process {
        id: rebootProc

        command: ["sh", "-c", "systemctl reboot"]
    }

    Process {
        id: hibernateProc

        command: ["sh", "-c", "systemctl hibernate"]
    }

    Rectangle {
        Layout.fillWidth: true
        color: logoutBtn.containsMouse ? Theme.recthovercolor : Theme.rectcolor
        implicitHeight: 30
        radius: States.tagRounding

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        Text {
            anchors.centerIn: parent
            text: "󰗽 Logout"
            color: Theme.text1
            font.family: Theme.fontfamily
        }

        MouseArea {
            id: logoutBtn

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: logoutProc.running = true
        }

    }

    Rectangle {
        Layout.fillWidth: true
        color: shutdownBtn.containsMouse ? Theme.recthovercolor : Theme.rectcolor
        implicitHeight: 30
        radius: States.tagRounding

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        Text {
            anchors.centerIn: parent
            text: "󰐥 Shut Down"
            color: Theme.text1
            font.family: Theme.fontfamily
        }

        MouseArea {
            id: shutdownBtn

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: shutdownProc.running = true
        }

    }

    Rectangle {
        Layout.fillWidth: true
        color: rebootBtn.containsMouse ? Theme.recthovercolor : Theme.rectcolor
        implicitHeight: 30
        radius: States.tagRounding

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        Text {
            anchors.centerIn: parent
            text: " Reboot"
            color: Theme.text1
            font.family: Theme.fontfamily
        }

        MouseArea {
            id: rebootBtn

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: rebootProc.running = true
        }

    }

    Rectangle {
        Layout.fillWidth: true
        color: hibernateBtn.containsMouse ? Theme.recthovercolor : Theme.rectcolor
        implicitHeight: 30
        radius: States.tagRounding

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        Text {
            anchors.centerIn: parent
            text: "󰒲 Hibernate"
            color: Theme.text1
            font.family: Theme.fontfamily
        }

        MouseArea {
            id: hibernateBtn

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: hibernateProc.running = true
        }

    }

}
