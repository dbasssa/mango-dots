import QtQuick
import Quickshell

Item {
    id: root
    property int fontSize: Theme.fontxxl
    implicitHeight: clktxt.implicitHeight
    implicitWidth: clktxt.implicitWidth
    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Text {
        id:clktxt
        text: Qt.formatDateTime(clock.date, "hh:mm")
        color: States.islandBar ? Theme.bgcolor : Theme.text1
        font.family: Theme.fontfamily
        font.pixelSize: root.fontSize
        font.bold: true
        onTextChanged: clkFade.restart()
    }

    SequentialAnimation {
        id: clkFade
        NumberAnimation { target: clktxt; property: "opacity"; from: 0.3; to: 1; duration: 350; easing.type: Easing.OutCubic }
    }

}
