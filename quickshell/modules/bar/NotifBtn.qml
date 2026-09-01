import Quickshell
import QtQuick

import qs.modules
import qs.modules.themeing

Rectangle {
    visible: States.notchBar ? false : true
    implicitHeight: 27
    implicitWidth: 30
    radius: 12
    color: Theme.rectcolor

    Text {
        anchors.centerIn: parent
        id: textId
        text: "󰂚"
        color: Theme.text1
        font {
            pixelSize: Theme.fontxl
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: States.notifOpen = !States.notifOpen
    }
}