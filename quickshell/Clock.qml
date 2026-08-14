import QtQuick
import Quickshell

Item {
    implicitHeight: clktxt.implicitHeight
    implicitWidth: clktxt.implicitWidth
    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Text {
        id:clktxt
        text: Qt.formatDateTime(clock.date, "hh:mm")
        color: Theme.text1
        font.family: Theme.fontfamily
        font.pixelSize: Theme.fontxl
        onTextChanged: clkFade.restart()
    }

    SequentialAnimation {
        id: clkFade
        NumberAnimation { target: clktxt; property: "opacity"; from: 0.3; to: 1; duration: 350; easing.type: Easing.OutCubic }
    }

}
