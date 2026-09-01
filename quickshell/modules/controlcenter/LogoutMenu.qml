import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import qs.modules.themeing

ColumnLayout {
    id: root
    anchors.horizontalCenter: parent.horizontalCenter
    implicitWidth: 350
    anchors.margins: 10

    Process {
        id: logoutProc
        command: ["sh", "-c", "loginctl terminate-user $USER"]
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

    RowLayout {
        Layout.fillWidth: true
        
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            color: logoutBtn.containsMouse ? Theme.recthovercolor : Theme.rectcolor
            implicitHeight: 30
            radius: 8
            border { width: 1; color: Theme.bordercolor }

            Text {
                anchors.centerIn: parent
                text: "󰗽"
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
            radius: 8
            border { width: 1; color: Theme.bordercolor }

            Text {
                anchors.centerIn: parent
                text: "󰐥"
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
    }

    RowLayout {
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            color: rebootBtn.containsMouse ? Theme.recthovercolor : Theme.rectcolor
            implicitHeight: 30
            radius: 8
            border { width: 1; color: Theme.bordercolor }

            Text {
                anchors.centerIn: parent
                text: ""
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
            radius: 8
            border { width: 1; color: Theme.bordercolor }

            Text {
                anchors.centerIn: parent
                text: "󰒲"
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
}
