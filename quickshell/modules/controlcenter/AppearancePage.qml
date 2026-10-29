import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules
import qs.modules.themeing

ColumnLayout {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 10

    function cycle(dir) {
        const n = ThemeState.themes.length;
        ThemeState.themeIndex = (ThemeState.themeIndex + dir + n) % n;
        ThemeState.saveTheme();
        WallpaperState.randomWal();
    }

    Text {
        text: "Appearance"
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontxxl
            bold: true
        }
    }

    //theme cycler
    RowLayout {
        Layout.fillWidth: true
        spacing: 4

        Rectangle {
            implicitWidth: 34
            implicitHeight: 34
            radius: States.tagRounding
            color: Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            Text {
                anchors.centerIn: parent
                text: "<"
                color: Theme.text1

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontlg
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.cycle(-1)
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 34
            radius: States.tagRounding
            color: Theme.bgcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            Text {
                anchors.centerIn: parent
                text: ThemeState.themes[ThemeState.themeIndex].name
                color: Theme.text1

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontlg
                    bold: true
                }
            }
        }

        Rectangle {
            implicitWidth: 34
            implicitHeight: 34
            radius: States.tagRounding
            color: Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            Text {
                anchors.centerIn: parent
                text: ">"
                color: Theme.text1

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontlg
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.cycle(1)
            }
        }
    }

    //theme color preview
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 6

        Repeater {
            model: [Theme.rectcolor, Theme.occupiedcolor, Theme.text1, Theme.textmuted, Theme.alertcolor, Theme.miconcolor]

            delegate: Rectangle {
                height: 14
                width: 26
                radius: 4
                color: modelData

                border {
                    width: 1
                    color: Theme.bordercolor
                }
            }
        }
    }

    Text {
        text: "Bar Style"
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontxl
            bold: true
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 4

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 30
            radius: States.tagRounding
            color: States.fullBar ? Theme.occupiedcolor : Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            Text {
                anchors.centerIn: parent
                text: "Full"
                color: Theme.text1
                font.family: Theme.fontfamily
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: States.fullBarSelect()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 30
            radius: States.tagRounding
            color: States.islandBar ? Theme.occupiedcolor : Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            Text {
                anchors.centerIn: parent
                text: "Island"
                color: Theme.text1
                font.family: Theme.fontfamily
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: States.islandBarSelect()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 30
            radius: States.tagRounding
            color: States.notchBar ? Theme.occupiedcolor : Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            Text {
                anchors.centerIn: parent
                text: "Notch"
                color: Theme.text1
                font.family: Theme.fontfamily
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: States.notchSelect()
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        implicitHeight: 30

        Text {
            Layout.fillWidth: true
            text: "Screen Frame"
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        ThemeSwitch {
            checked: States.frameVis
            onClicked: {
                States.frameVis = checked;
                States.saveState("framevis", checked);
            }
        }
    }

    Text {
        text: "Wallpaper"
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontxl
            bold: true
        }
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 30
        radius: States.tagRounding
        color: Theme.bgcolor

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        Text {
            anchors.fill: parent
            anchors.margins: 8
            text: WallpaperState.fileBasename(WallpaperState.currentWallpaper)
            color: Theme.textmuted
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontmd
            }
        }
    }

    WallBtn {}

    Item {
        Layout.fillHeight: true
    }
}
