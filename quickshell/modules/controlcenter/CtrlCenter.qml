import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules
import qs.modules.themeing

PanelWindow {
    visible: States.ctrlOpen
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    anchors {
        top: true
        right: true
        left: true
        bottom: true
    }

    margins {
        top: States.barHeight + States.frameThickness
        right: States.frameThickness + 2
    }

    MouseArea {
        anchors.fill: parent
        onClicked: States.ctrlOpen = !States.ctrlOpen
    }

    IpcHandler {
        function toggle() {
            States.ctrlOpen = !States.ctrlOpen;
        }

        target: "ctrlcntr-qs"
    }

    Rectangle {
        implicitHeight: centerCol.implicitHeight + 40
        implicitWidth: 400
        anchors.right: parent.right
        anchors.top: parent.top
        color: Theme.rectcolor
        radius: 20

        border {
            color: Theme.bordercolor
            width: 2
        }

        ColumnLayout {
            id: centerCol

            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape)
                    States.ctrlOpen = false;

            }

            Mpris {
            }

            VolumeCtrl {
            }

            Item {
                Layout.fillHeight: true
            }

            LogoutMenu {
            }

        }

    }

}
