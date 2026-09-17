import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules
import qs.modules.themeing

PanelWindow {
    id: root
    visible: States.ctrlOpen
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    NumberAnimation {
        id: openAnim
        target: ctrlrect
        property: "implicitHeight"
        duration: 400
        easing.type: Easing.OutCubic
    }
    onVisibleChanged: {
        openAnim.from = 0
        openAnim.to = ctrlrect.implicitHeight
        openAnim.restart()
    }

    anchors {
        top: true
        right: true
        left: true
        bottom: true
    }

    margins {
        top: States.barHeight + States.frameThickness + 5
        right: States.frameThickness + 5
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
        id:ctrlrect
        implicitHeight: 400
        implicitWidth: 400
        anchors.right:  parent.right 
        anchors.top: parent.top
        color: Theme.bgcolor
        radius: States.panelRounding
        clip: true

        border {
            color: Theme.bordercolor
            width: States.borderOn ? 2 : 0
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

            ThemeBtn {
            }

            WallBtn {
            }

            Item {
                Layout.fillHeight: true
            }

            LogoutMenu {
            }

        }

    }

}
