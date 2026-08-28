import QtQuick
import QtQuick.Layouts
import Quickshell

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
        color: States.islandBar ? "transparent" : Theme.bgcolor
        radius: States.fullBar ? 0 : 10

        border {
            width: States.fullBar ? 0 : 2
            color: Theme.bordercolor
        }

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

        Clock {
        }

        Item {
            Layout.fillWidth: true
        }

        SettingsBtn {
        }
        NotifBtn {}

        CtrlCenterBtn {
        }

    }

}
