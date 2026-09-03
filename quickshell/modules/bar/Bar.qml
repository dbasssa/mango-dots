import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.modules
import qs.modules.controlcenter
import qs.modules.themeing

PanelWindow {
    required property var modelData

    screen: modelData
    implicitHeight: States.barHeight
    implicitWidth: States.barWidth
    color: "transparent"

    anchors {
        top: true
        left: States.fullBar ? true : false
        right: States.fullBar ? true : false
    }

    margins {
        top: States.notchBar ? States.notchMargin : 0
    }

    Rectangle {
        anchors.fill: parent
        color: States.islandBar ? "transparent" : States.notchBar ? Theme.rectcolor : Theme.bgcolor
        radius: States.fullBar ? 0 : States.barRounding

    }

    RowLayout {
        anchors.leftMargin: States.barMargin
        anchors.rightMargin: States.barMargin
        spacing: 5
        anchors.fill: parent

        Item {
            Layout.fillWidth: true
            visible: States.notchBar ? true : false
        }

        Workspaces { monitor: modelData.name}

        FocusedApp {}

        Clock {}

        Item {Layout.fillWidth: true}
        
        SettingsBtn {
        }

        NotifBtn {}

        CtrlCenterBtn{}
    }

}
