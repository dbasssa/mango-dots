import Quickshell
import QtQuick
import QtQuick.Layouts


import qs.modules
import qs.modules.themeing

Rectangle {
    Layout.fillWidth: true
    implicitHeight: 30
    color: Theme.rectcolor
    radius: 20

    border {
        width:1
        color: Theme.bordercolor
    }

    Text {
        anchors.centerIn: parent
        text: "Change Theme"
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontmd
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {States.themeOpen = !States.themeOpen; States.ctrlOpen = false}
    }

}