import QtQuick
import Quickshell

import qs.modules
import qs.modules.themeing

Rectangle {
    id: root
    property int fontSize: Theme.fontxl
    property string rectColor: Theme.rectcolor

    color: rectColor
    implicitHeight: 25
    implicitWidth: clktxt.implicitWidth + 20
    radius: 20

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Text {
        id: clktxt
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "hh:mm")
        color: Theme.text1
        font.family: Theme.fontfamily
        font.pixelSize: root.fontSize
        font.bold: true
        onTextChanged: clkFade.restart()
    }

    SequentialAnimation {
        id: clkFade

        NumberAnimation {
            target: clktxt
            property: "opacity"
            from: 0.3
            to: 1
            duration: 350
            easing.type: Easing.OutCubic
        }

    }

}
