import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland


PanelWindow {
    id: root
    exclusionMode: ExclusionMode.Ignore
    visible: States.wallPickerOpen
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Component.onCompleted: WallpaperState.doScan()

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#99000000"
        opacity: 0

        onVisibleChanged: if (!root.visible) bg.opacity = 0

        ParallelAnimation {
            id: fadeIn
            running: root.visible
            NumberAnimation {
                target: bg
                property: "opacity"
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        Item {
            id: content
            anchors.fill: parent
            focus: true

            function move(dir) {
                if (list.count === 0) return
                list.currentIndex = (list.currentIndex + dir + list.count) % list.count
            }

            onVisibleChanged: if (root.visible) list.currentIndex = WallpaperState.currentIndex

            Keys.onLeftPressed: content.move(-1)
            Keys.onRightPressed: content.move(1)
            Keys.onReturnPressed: WallpaperState.apply()
            Keys.onEscapePressed: WallpaperState.closePicker()

            MouseArea {
                anchors.fill: parent
                onClicked: WallpaperState.closePicker()
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width - 120
                spacing: 16

                MouseArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                ListView {
                    id: list
                    Layout.fillWidth: true
                    Layout.preferredHeight: 660

                    model: WallpaperState.wallpapers
                    orientation: ListView.Horizontal
                    snapMode: ListView.SnapOneItem
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 80
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: 0.5
                    preferredHighlightEnd: 0.5
                    spacing: 10
                    clip: true
                    interactive: true

                    highlight: Rectangle { color: "transparent" }

                    currentIndex: -1
                    onCurrentIndexChanged: {
                        if (root.visible && list.count > 0) {
                            WallpaperState.currentIndex = list.currentIndex
                        }
                    }

                    delegate: Item {
                        id: thumb
                        width: 1000
                        height: 560

                        scale: ListView.isCurrentItem ? 1.15 : 1.0
                        opacity: ListView.isCurrentItem ? 1.0 : 0.55
                        z: ListView.isCurrentItem ? 2 : 1

                        Behavior on scale {
                            NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                        }
                        Behavior on opacity {
                            NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: 10
                            clip: true
                            color: Theme.rectcolor
                            border.color: ListView.isCurrentItem ? Theme.textactive : Theme.bordercolor
                            border.width: 2

                            Image {
                                anchors.fill: parent
                                anchors.margins: 4
                                asynchronous: true
                                fillMode: Image.PreserveAspectCrop
                                source: modelData
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: list.currentIndex = index
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                    }
                    text: {
                        if (list.count === 0) return "no wallpapers found in ~/walls/" + ThemeState.themes[ThemeState.currentIndex].wallFolder
                        const p = WallpaperState.wallpapers[list.currentIndex] || ""
                        return (list.currentIndex + 1) + " / " + list.count + "    " + p.split("/").pop()
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontsm
                    }
                    text: "← / → cycle    Enter apply    Esc close"
                }
            }
        }
    }
}
