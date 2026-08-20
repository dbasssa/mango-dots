import QtQuick
import Quickshell
import QtQuick.Layouts

PanelWindow {
    required property var modelData

    screen: modelData
    implicitHeight: 40
    implicitWidth: 650
    color: "transparent"
    anchors {
        top: true
    }
    margins {
        top: 5
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bgcolor
        radius: 10
        border {
            width: 2
            color: Theme.bordercolor
        }
    }

    RowLayout {
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        spacing: 5
        anchors.fill: parent

        Workspaces {monitorName: modelData.name }

        Item {
            Layout.fillWidth: true
        }
        Clock {
        }

        Item {
            Layout.fillWidth: true
        }
        CtrlCenterBtn{}

    }

}
