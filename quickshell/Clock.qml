import QtQuick
import Quickshell

Rectangle {
    id: root
    property int fontSize: Theme.fontxxl
    property string rectColor: Theme.bgcolor

    color: rectColor
    implicitHeight: clktxt.implicitHeight + 5
    implicitWidth: clktxt.implicitWidth + 20
    radius: 8
    border {
        width: States.islandBar ? (States.lockScreen ? 0 : 2) : 0
        color: Theme.bordercolor
    }

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
