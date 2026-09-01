import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.modules
import qs.modules.themeing

Rectangle {
    id: root
    visible: States.notchBar ? false : true
    Layout.alignment: Qt.AlignVCenter
    implicitHeight: 28
    implicitWidth: btnRow.implicitWidth + 24
    color: ctrlMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
    Behavior on color { ColorAnimation { duration: 150 } }
    radius: 12


    RowLayout {
        id: btnRow
        anchors.centerIn: parent
        spacing: 0
        VolumeBar {}

        Text {
            text: " | "
            color: Theme.bordercolor
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontxxl
        }

        Text {
            text: ""
            color: Theme.text1
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontxxl
        }        

        Text {
            text: " | "
            color: Theme.bordercolor
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontxxl
        }

        Text {
            text: "󰍜"
            color: States.ctrlOpen ? Theme.textactive : Theme.text1
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontxxl
            rotation: States.ctrlOpen ? 90 : 0
            Behavior on rotation { NumberAnimation { duration: 350; easing.type: Easing.InOutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: ctrlMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {States.ctrlOpen = !States.ctrlOpen; States.appOpen = false}
    }

}
