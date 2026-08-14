import QtQuick
import Quickshell
import QtQuick.Layouts

PanelWindow {
    required property var modelData

    screen: modelData
    implicitHeight: 40
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bgcolor
    }

    RowLayout {
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        spacing: 5
        anchors.fill: parent

        Workspaces {
            monitorName: modelData.name
        }

        Item {
            Layout.fillWidth: true
        }
        Clock {
        }

        Item {
            Layout.fillWidth: true
        }
        VolumeBar{}
        NotifBtn{}
        CtrlCenterBtn{}

    }

}
