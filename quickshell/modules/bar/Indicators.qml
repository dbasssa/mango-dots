import QtQuick
import QtQuick.Layouts

import qs.modules
import qs.modules.themeing
import qs.services

//compact pill that only appears when a mode is active (or a keyboard layout
//is known), showing caps lock, mic/output mute, DND, keymode and layout
Rectangle {
    id: root

    readonly property bool showCaps: InputState.capsLock
    readonly property bool showMic: Pipewire.micMuted
    readonly property bool showOutput: Pipewire.muted
    readonly property bool showDnd: NotificationState.dnd
    readonly property bool showKeymode: InputState.keymode !== "" && InputState.keymode !== "default"
    readonly property bool showLayout: InputState.layoutLabel !== ""

    visible: !States.notchBar && (showCaps || showMic || showOutput || showDnd || showKeymode || showLayout)
    Layout.alignment: Qt.AlignHCenter
    implicitHeight: Math.round(States.barHeight * 0.75)
    implicitWidth: row.implicitWidth + 12
    color: Theme.rectcolor
    radius: States.itemRounding

    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    RowLayout {
        id: row

        anchors.fill: parent
        anchors.leftMargin: 6
        anchors.rightMargin: 6
        spacing: 5

        Text {
            visible: root.showCaps
            //md-caps_lock
            text: "\uDB82\uDE9B"
            color: Theme.alertcolor

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        Text {
            visible: root.showMic
            //md-microphone_off
            text: "\uDB80\uDF6D"
            color: Theme.alertcolor

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        Text {
            visible: root.showOutput
            //md-volume_off
            text: "\uDB81\uDD81"
            color: Theme.alertcolor

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        Text {
            visible: root.showDnd
            //fa-bell_slash
            text: "\uF1F6"
            color: Theme.textactive

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        Text {
            visible: root.showKeymode
            text: InputState.keymode
            color: Theme.miconcolor

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontsm
            }
        }

        Text {
            visible: root.showLayout
            text: InputState.layoutLabel
            color: Theme.textmuted

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontsm
            }
        }
    }
}
