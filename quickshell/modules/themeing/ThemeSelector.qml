import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules

PanelWindow {
    id: root

    //apply a theme and close the picker
    function select(index) {
        if (index < 0 || index >= ThemeState.themes.length)
            return;

        ThemeState.themeIndex = index;
        ThemeState.saveTheme();
        //grab a wallpaper that matches the new theme
        WallpaperState.randomWal();
        States.themeOpen = false;
    }

    visible: States.themeOpen
    color: "#99000000"
    exclusionMode: ExclusionMode.Ignore
    focusable: true
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    onVisibleChanged: {
        if (!root.visible)
            return;

        //start on the theme that is currently applied
        themeGrid.currentIndex = ThemeState.themeIndex;
        themeGrid.positionViewAtIndex(themeGrid.currentIndex, GridView.Center);
    }

    anchors {
        top: true
        right: true
        left: true
        bottom: true
    }

    IpcHandler {
        function toggle() {
            States.themeOpen = !States.themeOpen;
        }

        target: "themesw-qs"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: States.themeOpen = false
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: root.width - 80
        spacing: 14

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Themes"
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontxl
                bold: true
            }

        }

        GridView {
            id: themeGrid

            Layout.fillWidth: true
            Layout.preferredHeight: 420
            cellWidth: 200
            cellHeight: 200
            clip: true
            focus: root.visible
            model: ThemeState.themes
            currentIndex: ThemeState.themeIndex
            keyNavigationEnabled: false
            boundsBehavior: Flickable.StopAtBounds

            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape) {
                    States.themeOpen = false;
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    root.select(themeGrid.currentIndex);
                } else if (event.key === Qt.Key_Left || event.key === Qt.Key_H) {
                    themeGrid.moveCurrentIndexLeft();
                } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
                    themeGrid.moveCurrentIndexRight();
                } else if (event.key === Qt.Key_Up || event.key === Qt.Key_K) {
                    themeGrid.moveCurrentIndexUp();
                } else if (event.key === Qt.Key_Down || event.key === Qt.Key_J) {
                    themeGrid.moveCurrentIndexDown();
                } else {
                    return;
                }
                event.accepted = true;
            }

            delegate: Rectangle {
                id: themeCard

                required property int index
                required property var modelData

                width: 186
                height: 186
                radius: States.tagRounding
                color: themeCard.modelData.bgcolor

                border {
                    width: themeGrid.currentIndex === themeCard.index ? 3 : 1
                    color: themeGrid.currentIndex === themeCard.index ? themeCard.modelData.textactive : themeCard.modelData.bordercolor
                }

                Behavior on border.width {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }

                //miniature of the shell in this theme
                Rectangle {
                    id: preview

                    anchors.fill: parent
                    anchors.margins: 10
                    radius: States.sliderRounding
                    color: themeCard.modelData.rectcolor

                    //bar
                    Rectangle {
                        id: previewBar

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 22
                        radius: States.sliderRounding
                        color: themeCard.modelData.bgcolor
                    }

                    //tab strip
                    Row {
                        id: previewTabs

                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.top: previewBar.bottom
                        anchors.topMargin: 10
                        spacing: 5

                        Rectangle {
                            width: 26
                            height: 12
                            radius: 3
                            color: themeCard.modelData.textactive
                        }

                        Rectangle {
                            width: 26
                            height: 12
                            radius: 3
                            color: themeCard.modelData.bordercolor
                        }

                        Rectangle {
                            width: 26
                            height: 12
                            radius: 3
                            color: themeCard.modelData.bordercolor
                        }
                    }

                    //slider
                    Rectangle {
                        id: previewTrack

                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.top: previewTabs.bottom
                        anchors.topMargin: 16
                        height: 5
                        radius: 3
                        color: themeCard.modelData.bordercolor

                        Rectangle {
                            width: parent.width * 0.6
                            height: parent.height
                            radius: parent.radius
                            color: themeCard.modelData.textactive
                        }
                    }

                    //status dots
                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 12
                        spacing: 6

                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: themeCard.modelData.miconcolor
                        }

                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: themeCard.modelData.alertcolor
                        }
                    }
                }

                //theme name
                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 14
                    horizontalAlignment: Text.AlignHCenter
                    text: themeCard.modelData.name
                    color: themeCard.modelData.text1
                    elide: Text.ElideRight
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontbase
                        bold: true
                    }
                }

                //applied marker
                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    visible: themeCard.index === ThemeState.themeIndex
                    text: "󰄬"
                    color: themeCard.modelData.textactive
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontbase
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.select(themeCard.index)
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "←/→/↑/↓ or h/j/k/l to move · Enter to select · Esc to close"
            color: Theme.textmuted

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontsm
            }

        }
    }

}
