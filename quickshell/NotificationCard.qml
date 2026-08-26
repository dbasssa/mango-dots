import QtQuick
import QtQuick.Layouts

// Single notification card. Top bar shows the app name with an X to clear
// the notification; tapping anywhere else focuses the app that sent it.
// Clearing (X or tap) dismisses the notification and removes it from
// persistent memory. Auto-expiry (timer) only dismisses, keeping it in the
// notification center.
Rectangle {
    id: root

    required property var modelData

    property color cardColor: Theme.rectcolor
    property color borderColor: Theme.bordercolor
    property int borderWidth: 1

    radius: 12
    color: root.cardColor

    Layout.fillWidth: true

    border {
        width: root.borderWidth
        color: root.borderColor
    }

    implicitHeight: Math.max(64, content.implicitHeight + 16)

    opacity: 0
    transform: Translate { id: cardT; y: -8 }

    Component.onCompleted: cardIn.start()

    ParallelAnimation {
        id: cardIn
        NumberAnimation { target: root; property: "opacity"; to: 1; duration: 200; easing.type: Easing.OutCubic }
        NumberAnimation { target: cardT; property: "y"; to: 0; duration: 240; easing.type: Easing.OutCubic }
    }

    // Tap anywhere except the X → focus the app and clear the notification.
    MouseArea {
        id: tapArea
        anchors.fill: parent
        onClicked: {
            if (!root.modelData) return
            NotificationState.focusApp(root.modelData)
            root.modelData.dismiss()
            NotificationState.remove(root.modelData)
        }
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                Layout.fillWidth: true
                visible: text !== ""
                text: root.modelData ? root.modelData.appName : ""
                color: Theme.textmuted
                font.family: Theme.fontfamily
                font.pixelSize: Theme.fontsm
                font.bold: true
                elide: Text.ElideRight
            }

            Rectangle {
                id: clearBtn
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignVCenter
                radius: 4
                color: clearMouse.containsMouse ? Theme.bordercolor : "transparent"
                scale: clearMouse.containsMouse ? 1.15 : 1.0
                Behavior on color { ColorAnimation { duration: 120 } }
                Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

                Text {
                    anchors.centerIn: parent
                    text: "\uf00d"
                    color: clearMouse.containsMouse ? Theme.alertcolor : Theme.textmuted
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontxs
                    Behavior on color { ColorAnimation { duration: 120 } }
                }

                MouseArea {
                    id: clearMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (!root.modelData) return
                        root.modelData.dismiss()
                        NotificationState.remove(root.modelData)
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Image {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                Layout.alignment: Qt.AlignTop
                fillMode: Image.PreserveAspectFit
                visible: source.toString() !== ""
                source: root.modelData ? (root.modelData.image || root.modelData.appIcon || "") : ""
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    visible: text !== ""
                    text: root.modelData ? root.modelData.summary : ""
                    color: Theme.text1
                    font.family: Theme.fontfamily
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    visible: text !== ""
                    text: root.modelData ? root.modelData.body : ""
                    color: Theme.text1
                    font.family: Theme.fontfamily
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
