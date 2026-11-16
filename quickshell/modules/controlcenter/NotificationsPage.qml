import QtQuick
import QtQuick.Layouts
import qs.modules.themeing
import qs.services

ColumnLayout {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 8

    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Text {
            Layout.fillWidth: true
            text: "Notifications"
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontxxl
                bold: true
            }
        }

        Text {
            text: "Do Not Disturb"
            color: NotificationState.dnd ? Theme.textactive : Theme.textmuted

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontmd
            }
        }

        ThemeSwitch {
            checked: NotificationState.dnd
            onClicked: NotificationState.dnd = checked
        }

        Text {
            text: "Clear All"
            color: clearHover.containsMouse && NotificationState.history.length > 0 ? Theme.textactive : (NotificationState.history.length > 0 ? Theme.text1 : Theme.textmuted)

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }

            MouseArea {
                id: clearHover

                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: NotificationState.clearHistory()
            }
        }
    }

    Text {
        Layout.fillWidth: true
        visible: NotificationState.dnd
        text: "Critical notifications still get through"
        color: Theme.textmuted
        wrapMode: Text.WordWrap

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontsm
        }
    }

    ListView {
        id: list

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 320
        spacing: 8
        clip: true
        model: NotificationState.history

        delegate: NotificationCard {
            required property var modelData

            width: list.width
            notification: modelData.view
            timeLabel: modelData.time
            hoverHighlight: true

            onBodyClicked: NotificationState.dismissEntry(modelData)
        }
    }
}
