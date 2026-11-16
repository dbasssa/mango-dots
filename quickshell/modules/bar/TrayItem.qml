import Quickshell
import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import qs.modules


Item {
    anchors.verticalCenter: parent.verticalCenter
    visible: States.notchBar ? false : States.trayVisible
    implicitHeight: Math.round(States.barHeight * 0.5)
    implicitWidth: Math.round(States.barHeight * 0.50)


    IconImage {
        id: trayIcon
        anchors.centerIn: parent
        //visible: !modelData.onlyMenu
        source: modelData.icon
        width: Math.round(States.barHeight * 0.5)
        height: Math.round(States.barHeight * 0.5)
        opacity: trayMouse.containsMouse ? 1 : 0.8
    }

    QsMenuAnchor {
        id: trayMenu
        menu: modelData.menu
        anchor.item: parent
    }

    MouseArea {
        id: trayMouse
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked : (mouse) => {
            switch (mouse.button) {
                case Qt.LeftButton: 
                    modelData.activate()
                    break
                case Qt.RightButton:
                    if (modelData.hasMenu) trayMenu.open()
                    else modelData.secondaryActivate()
                    break
                case Qt.MiddleButton: 
                    modelData.secondaryActivate()
                    break
            }
        }
        onWheel: (wheel) => {
            modelData.scroll(wheel.angleDelta.y, false)
        }
    }
}