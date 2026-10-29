import QtQuick
import Quickshell

import qs.modules
import qs.modules.themeing

Rectangle {
    id: root
    visible: States.clockVisible
    property real fontSize: Theme.fontxl * States.fontScale
    property string rectColor: Theme.rectcolor

    property bool dateShow: false
    anchors.centerIn: parent
    implicitWidth: clktxt.implicitWidth + 15
    implicitHeight: States.lockScreen ? 50 : Math.round(States.barHeight * 0.75)
    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    color: States.flushItems ? Theme.bgcolor : Theme.rectcolor
    radius: States.panelRounding

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }
    Text {
        id: clktxt
        anchors.centerIn: parent
        text: root.dateShow ? Qt.formatDateTime(clock.date, "dd MMM yyyy") : Qt.formatDateTime(clock.date, "hh:mm")
        color: Theme.text1
        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontlg
            bold: true
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.dateShow = !root.dateShow
    }
}
