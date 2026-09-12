import QtQuick
import Quickshell
import QtQuick.Layouts

import qs.modules
import qs.modules.themeing





Rectangle {
    visible: States.clockVisible
    id: root
    property int fontSize: Theme.fontxl
    property string rectColor: Theme.rectcolor

    property bool dateShow: false
    property real cellH: Math.max(14, root.fontSize * 1.50)
    property real cellW: root.fontSize * (root.dateShow ? 0.9 : 0.62)
    property string timeText: {root.dateShow
        ? Qt.formatDateTime(clock.date, "dd MMM yyyy")
        : Qt.formatDateTime(clock.date, "hh:mm")
    }
    anchors.centerIn: parent

    color: rectColor
    implicitHeight: States.lockScreen ? root.cellH : 25
    implicitWidth: txtRow.implicitWidth + 20
    radius: 20

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

Row {
        id: txtRow
        anchors.centerIn: parent
        spacing: 0
        Repeater {
            model: root.timeText.length
            delegate: Item {
                id: cell
                property string char: root.timeText[index]
                property string shown: cell.char
                property real rollDuration: 260
                width: root.cellW
                height: root.cellH
                clip: true

                Text {
                    id: cur
                    anchors.verticalCenter: parent.verticalCenter
                    y: 0
                    text: cell.shown
                    color: Theme.text1
                    font.family: Theme.fontfamily
                    font.pixelSize: root.fontSize
                    font.bold: true
                }

                Text {
                    id: nxt
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: -parent.height
                    text: cell.shown
                    color: Theme.text1
                    font.family: Theme.fontfamily
                    font.pixelSize: root.fontSize
                    font.bold: true
                }

                ParallelAnimation {
                    id: roll
                    NumberAnimation { target: cur; property: "y"; to: cell.height; duration: cell.rollDuration; easing.type: Easing.InOutCubic }
                    NumberAnimation { target: nxt; property: "y"; to: 0; duration: cell.rollDuration; easing.type: Easing.InOutCubic }
                    onFinished: {
                        cell.shown = cell.char
                        cur.text = cell.shown
                        cur.y = 0
                        nxt.text = cell.shown
                        nxt.y = -cell.height
                    }
                }

                onCharChanged: {
                    if (cell.char === cell.shown || cell.char === "" || cell.char === undefined)
                        return;
                    if (roll.running) {
                        roll.stop();
                        cell.shown = cell.char;
                        cur.text = cell.shown;
                        cur.y = 0;
                        nxt.text = cell.shown;
                        nxt.y = -cell.height;
                        return;
                    }
                    nxt.text = cell.char;
                    roll.restart();
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.dateShow = !root.dateShow
    }

}
