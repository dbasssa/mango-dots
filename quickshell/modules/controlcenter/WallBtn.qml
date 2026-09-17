import Quickshell
import QtQuick
import QtQuick.Layouts


import qs.modules
import qs.modules.themeing

Rectangle {
    Layout.fillWidth: true
    implicitHeight: 30
    color: Theme.rectcolor
    radius: States.panelRounding

    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    Text {
        anchors.centerIn: parent
        text: "Change Wallpaper"
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontmd
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {States.wallOpen = !States.wallOpen; States.ctrlOpen = false}
    }

}