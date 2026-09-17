import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

import qs.modules
import qs.modules.themeing
Rectangle {
    visible: SystemTray.items.count > 0
    Layout.alignment: Qt.AlignHCenter
    implicitHeight: Math.round(States.barHeight * 0.75)
    implicitWidth: row.implicitWidth + 10
    color: Theme.rectcolor
    radius: States.itemRounding
    RowLayout {
        id: row
        anchors.fill:parent
        anchors.margins: 5

        Repeater {
            model: SystemTray.items
            delegate: TrayItem {}
        }
    }
}