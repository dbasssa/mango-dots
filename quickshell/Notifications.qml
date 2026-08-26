import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root

    NotificationServer {
        id: sever

        actionsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: n => {
            n.tracked = true
            NotificationState.add(n)
        }
    }

    // single notification popup
    PanelWindow {
        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            right: true
        }

        margins {
            top: 47
            right: 8
        }

        ColumnLayout {
            id: column

            width: parent.width
            spacing: 10

            Repeater {
                model: sever.trackedNotifications

                delegate: NotificationCard {
                    cardColor: Theme.bgcolor
                    borderColor: Theme.bordercolor
                    borderWidth: 2

                    Timer {
                        running: modelData && modelData.urgency !== NotificationUrgency.Critical
                        interval: 5000
                        onTriggered: if (modelData) modelData.dismiss()
                    }
                }
            }

        }

    }

}
