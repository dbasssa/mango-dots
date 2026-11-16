import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.modules
import qs.modules.themeing
import qs.services

Scope {
    id: root

    PanelWindow {
        color: "transparent"
        implicitWidth: 380
        implicitHeight: column.implicitHeight
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay

        anchors {
            top: true
            right: true
        }

        margins {
            top: States.barHeight + States.frameThickness + 5
            right: States.notifCardSideMargin
        }

        ColumnLayout {
            id: column

            width: parent.width
            spacing: 10

            Repeater {
                model: NotificationState.server.trackedNotifications

                delegate: NotificationCard {
                    required property var modelData

                    notification: modelData
                    autoTimeout: true
                    cardRadius: States.frameRounding
                    borderThick: 2

                    //DND hides non-critical cards live; they still time out
                    //and stay in the history page
                    visible: NotificationState.shouldDisplay(modelData)

                    //acknowledging a popup hides the card but keeps the
                    //notification (and its actions) in history
                    onBodyClicked: modelData.tracked = false
                }
            }
        }
    }
}
