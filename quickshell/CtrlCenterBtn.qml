import QtQuick
import Quickshell

Rectangle {
    implicitHeight: 28
    implicitWidth: 35
    color: ctrlMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
    Behavior on color { ColorAnimation { duration: 150 } }
    radius:5

    border {
        width: 1
        color: Theme.bordercolor
    }

    scale: ctrlMouse.containsMouse ? 1.1 : 1.0
    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

    Text {
        anchors.centerIn:parent
        text: "󰍜"
        color: CtrlCenterState.ctrlOpen ? Theme.textactive : Theme.text1
        font.family: Theme.fontfamily
        font.pixelSize: Theme.fontxxl
        rotation: CtrlCenterState.ctrlOpen ? 90 : 0
        Behavior on rotation { NumberAnimation { duration: 350; easing.type: Easing.InOutCubic } }
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    MouseArea {
        id: ctrlMouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: CtrlCenterState.ctrlOpen = !CtrlCenterState.ctrlOpen
    }

}
