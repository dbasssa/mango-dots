import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    Layout.alignment: Qt.AlignVCenter
    Layout.preferredHeight: 28
    Layout.preferredWidth: 40
    radius: 6
    color: notifMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
    Behavior on color { ColorAnimation { duration: 150 } }
    border.width: 1
    border.color: Theme.bordercolor
    scale: notifMouse.containsMouse ? 1.1 : 1.0
    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

    Text {
        id: badge
        anchors.centerIn: parent
        text: NotificationState.persistent.length + " "
        font.family: Theme.fontfamily
        font.pixelSize: Theme.fontlg
        color: NotificationState.centerOpen || NotificationState.persistent.length > 0 ? Theme.textactive : Theme.textmuted
        Behavior on color { ColorAnimation { duration: 150 } }
        onTextChanged: badgePop.restart()
    }

    SequentialAnimation {
        id: badgePop
        NumberAnimation { target: badge; property: "scale"; from: 0.85; to: 1.05; duration: 110; easing.type: Easing.OutCubic }
        NumberAnimation { target: badge; property: "scale"; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
    }

    MouseArea {
        id: notifMouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: NotificationState.centerOpen = !NotificationState.centerOpen
    }

}
