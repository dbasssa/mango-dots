import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

import qs.modules
import qs.modules.themeing

//pill holding the system tray icons. it disappears completely when the bar
//style or the user setting hides the tray, so an empty pill isn't left behind.
Rectangle {
    id: root

    visible: !States.notchBar && States.trayVisible && SystemTray.items.values.length > 0
    Layout.alignment: Qt.AlignHCenter
    implicitHeight: Math.round(States.barHeight * 0.75)
    implicitWidth: row.implicitWidth + 10
    color: Theme.rectcolor
    radius: States.itemRounding

    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    RowLayout {
        id: row

        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: 1

        Repeater {
            model: SystemTray.items

            delegate: TrayItem {}
        }
    }
}
