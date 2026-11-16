import Quickshell
import QtQuick

import qs.modules
import qs.modules.themeing

Rectangle {
    visible: States.notchBar ? false : States.buttonsVisible
    implicitHeight: Math.round(States.barHeight * 0.75)
    implicitWidth: Math.round(States.barHeight * 0.75)
    radius: States.itemRounding
    color: clipMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor

    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    Text {
        anchors.centerIn: parent
        //md-clipboard_text
        text: "\uDB80\uDD4D"
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontxl
        }
    }

    MouseArea {
        id: clipMouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: States.clipboardOpen = !States.clipboardOpen
    }
}
