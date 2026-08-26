import Quickshell
import QtQuick

Rectangle {
    visible: States.notchBar ? false : true
    implicitHeight: 27
    implicitWidth: 30
    radius: 5
    color: Theme.rectcolor
    border {
        width: 1
        color: Theme.bordercolor

    }

    Text {
        anchors.centerIn: parent
        id: textId
        text: ""
        color: Theme.text1
        font {
            pixelSize: Theme.fontxl
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: States.settingsOpen = !States.settingsOpen
    }
}