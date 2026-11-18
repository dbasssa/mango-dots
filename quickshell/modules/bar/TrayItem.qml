import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.modules
import qs.modules.themeing

//single tray entry: left click activates, right click opens the item's menu,
//middle click (or right click when there is no menu) runs the secondary action
Item {
    id: root

    implicitHeight: Math.round(States.barHeight * 0.55)
    implicitWidth: Math.round(States.barHeight * 0.55)

    Rectangle {
        anchors.fill: parent
        radius: States.sliderRounding
        color: trayMouse.containsMouse ? Theme.recthovercolor : "transparent"
    }

    IconImage {
        id: trayIcon

        anchors.centerIn: parent
        source: modelData.icon
        width: Math.round(States.barHeight * 0.5)
        height: Math.round(States.barHeight * 0.5)
        opacity: trayMouse.containsMouse ? 1 : 0.85
    }

    QsMenuAnchor {
        id: trayMenu

        menu: modelData.menu
        anchor.item: root
    }

    MouseArea {
        id: trayMouse

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: (mouse) => {
            //menu-only entries have nothing to activate
            if (modelData.onlyMenu) {
                if (modelData.hasMenu)
                    trayMenu.open();
                return;
            }
            switch (mouse.button) {
            case Qt.LeftButton:
                modelData.activate();
                break;
            case Qt.RightButton:
                if (modelData.hasMenu)
                    trayMenu.open();
                else
                    modelData.secondaryActivate();
                break;
            case Qt.MiddleButton:
                modelData.secondaryActivate();
                break;
            }
        }
        onWheel: (wheel) => {
            modelData.scroll(wheel.angleDelta.y, false);
        }
    }
}
