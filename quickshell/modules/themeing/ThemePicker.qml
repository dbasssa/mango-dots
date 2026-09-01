import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import qs.modules

PanelWindow {
    id: root
    exclusionMode: ExclusionMode.Ignore
    visible: States.themePickerOpen
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    anchors { top: true; left: true; right: true; bottom: true }

    property int cols: 3
    property int cardW: 280
    property int cardH: 180
    property int cardSpacing: 20

    function move(dir) {
        var next = ThemeState.currentIndex + dir
        if (next < 0) next = ThemeState.themes.length - 1
        if (next >= ThemeState.themes.length) next = 0
        ThemeState.setTheme(next)
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#99000000"
        opacity: 0

        onVisibleChanged: if (!root.visible) bg.opacity = 0

        ParallelAnimation {
            id: fadeIn
            running: root.visible
            NumberAnimation { target: bg; property: "opacity"; to: 1; duration: 200; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: States.themePickerOpen = false
        }

        Item {
            anchors.fill: parent
            focus: true

            Keys.onLeftPressed: root.move(-1)
            Keys.onRightPressed: root.move(1)
            Keys.onUpPressed: root.move(-root.cols)
            Keys.onDownPressed: root.move(root.cols)
            Keys.onReturnPressed: States.themePickerOpen = false
            Keys.onEscapePressed: States.themePickerOpen = false

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 16

                MouseArea { Layout.fillWidth: true; Layout.fillHeight: true }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: Theme.text1
                    font { family: Theme.fontfamily; pixelSize: Theme.fontxl }
                    text: "Choose Theme"
                }

                Flow {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: root.cols * (root.cardW + root.cardSpacing) - root.cardSpacing
                    spacing: root.cardSpacing

                    Repeater {
                        model: ThemeState.themes

                        Rectangle {
                            id: card
                            width: root.cardW
                            height: root.cardH
                            radius: 10
                            color: ThemeState.currentIndex === index ? Theme.recthovercolor : Theme.rectcolor
                            border.color: ThemeState.currentIndex === index ? Theme.textactive : Theme.bordercolor
                            border.width: ThemeState.currentIndex === index ? 2 : 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 6

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    color: Theme.text1
                                    font { family: Theme.fontfamily; pixelSize: Theme.fontmd }
                                    text: modelData.name
                                }

                                Row {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 4

                                    Repeater {
                                        model: [modelData.bgcolor, modelData.rectcolor, modelData.text1, modelData.textactive, modelData.alertcolor, modelData.miconcolor]

                                        Rectangle {
                                            width: 30; height: 20; radius: 4
                                            color: modelData
                                            border.color: Theme.bordercolor; border.width: 1
                                        }
                                    }
                                }

                                Item { Layout.fillHeight: true }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: ThemeState.setTheme(index)
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: Theme.textmuted
                    font { family: Theme.fontfamily; pixelSize: Theme.fontsm }
                    text: "←/→/↑/↓ select    Enter / Esc close"
                }
            }
        }
    }
}
