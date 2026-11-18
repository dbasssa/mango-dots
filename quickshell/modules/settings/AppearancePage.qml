import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules
import qs.modules.themeing

Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: Theme.bgcolor

    //refresh wallpaper counts when the appearance page is opened
    onVisibleChanged: if (visible) WallpaperState.rescan()

    //shared by the numeric fields
    function intError(t) {
        if (t == null)
            return "";
        if (t.trim() === "")
            return "";
        var v = parseInt(t);
        if (isNaN(v))
            return "Enter a whole number.";
        if (v < 0)
            return "Value can't be negative.";
        return "";
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            text: "Theme"
            color: Theme.text1
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontxxl
                bold: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 50
            radius: States.tagRounding
            color: Theme.rectcolor
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

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: States.themeOpen = true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 50
            radius: States.tagRounding
            color: Theme.rectcolor
            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            Text {
                anchors.centerIn: parent
                text: WallpaperState.fileBasename(WallpaperState.currentWallpaper)
                color: Theme.textmuted
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontmd
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: States.wallOpen = true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            radius: States.itemRounding
            color: Theme.bgcolor
            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: "Border: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }
                Text {
                    text: "toggle the screen border on/off"
                    color: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }
                Item {
                    Layout.fillWidth: true
                }
                ThemeSwitch {
                    checked: States.borderOn
                    onClicked: States.borderOn = checked
                }
            }
        }

        Rectangle {
            implicitHeight: 70
            Layout.fillWidth: true
            color: Theme.bgcolor
            radius: States.itemRounding
            RowLayout {
                anchors.centerIn: parent
                spacing: 10

                Text {
                    Layout.alignment: Qt.AlignVCenter
                    text: "Border Thickness: "
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                TextField {
                    id: appearanceBorderThickField
                    implicitHeight: 50
                    implicitWidth: 100
                    placeholderText: States.borderThick
                    placeholderTextColor: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                    color: Theme.text1

                    background: Rectangle {
                        anchors.fill: parent
                        color: Theme.rectcolor
                        radius: States.tagRounding
                    }

                    onAccepted: {
                        var val = parseInt(text);
                        if (!isNaN(val) && val >= 0) {
                            States.borderThick = val;
                        }
                    }
                }

                Text {
                    visible: intError(appearanceBorderThickField.text) !== ""
                    text: intError(appearanceBorderThickField.text)
                    color: Theme.alertcolor
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontsm
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
