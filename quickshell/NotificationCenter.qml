import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

// Persistent center panel of notifications. Holds notifications until
// dismissed individually (card click) or cleared. Toggled from the bar
// button via NotificationState.centerOpen.
PanelWindow {
    id: root

    property bool open
    property bool animOpen: false

    visible: animOpen
    implicitWidth: 380
    implicitHeight: Math.max(320, column.implicitHeight + 24)
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
        top: true
        right: true
    }

    margins {
        top: 47
        right: 8
    }

    onOpenChanged: {
        if (root.open) {
            root.animOpen = true
            Qt.callLater(panelIn.start)
        } else {
            panelOut.start()
        }
    }

    Rectangle {
        id: panelBody
        anchors.fill: parent
        radius: 12
        color: Theme.bgcolor
        opacity: 0
        scale: 0.97
        transform: Translate { id: panelT; y: -14 }

        border {
            width: 2
            color: Theme.bordercolor
        }

        ColumnLayout {
            id: column

            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            Text {
                text: "Notifications"
                font.family: Theme.fontfamily
                font.pixelSize: Theme.fontxl
                font.bold: true
                color: Theme.text1
            }

            Repeater {
                model: NotificationState.persistent

                delegate: NotificationCard {}
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                radius: 6
                color: clearMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
                Behavior on color { ColorAnimation { duration: 150 } }
                scale: clearMouse.containsMouse ? 1.03 : 1.0
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

                border {
                    width: 1
                    color: Theme.bordercolor
                }

                Text {
                    anchors.centerIn: parent
                    text: "Clear"
                    color: clearMouse.containsMouse ? Theme.textactive : Theme.text1
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontbase
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                MouseArea {
                    id: clearMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: NotificationState.clearAll()
                }

            }

        }

    }

    ParallelAnimation {
        id: panelIn
        NumberAnimation { target: panelBody; property: "opacity"; to: 1; duration: 200; easing.type: Easing.OutCubic }
        NumberAnimation { target: panelT; property: "y"; to: 0; duration: 240; easing.type: Easing.OutCubic }
        NumberAnimation { target: panelBody; property: "scale"; to: 1; duration: 200; easing.type: Easing.OutCubic }
    }

    SequentialAnimation {
        id: panelOut
        ParallelAnimation {
            NumberAnimation { target: panelBody; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InCubic }
            NumberAnimation { target: panelT; property: "y"; to: -14; duration: 170; easing.type: Easing.InCubic }
            NumberAnimation { target: panelBody; property: "scale"; to: 0.97; duration: 150; easing.type: Easing.InCubic }
        }
        ScriptAction { script: root.animOpen = false }
    }

}
