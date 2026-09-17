import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules

PanelWindow {
    visible: States.themeOpen
    color: "#99000000"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }

    IpcHandler {
        function toggle() {
            States.themeOpen = !States.themeOpen;
        }

        target: "themesw-qs"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: States.themeOpen = !States.themeOpen
    }

    Rectangle {
        implicitHeight: 170
        implicitWidth: themeRow.implicitWidth + 120
        anchors.centerIn: parent
        color: Theme.bgcolor
        radius: States.panelRounding

        border {
            width: 2
            color: Theme.bordercolor
        }

        RowLayout {
            id: themeRow

            anchors.fill: parent
            spacing: 2
            anchors.margins: 10

            Repeater {
                model: ThemeState.themes

                delegate: Rectangle {
                    implicitHeight: 150
                    implicitWidth: 170
                    color: modelData.rectcolor
                    radius: States.tagRounding

                    border {
                        width: 4
                        color: Theme.bordercolor
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: modelData.name
                            color: modelData.text1

                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontlg
                            }

                        }

                        RowLayout {
                            spacing: 4
                            Layout.alignment: Qt.AlignHCenter

                            Repeater {
                                model: [modelData.bordercolor, modelData.text1, modelData.textmuted, modelData.alertcolor]

                                delegate: Rectangle {
                                    height: 20
                                    width: 20
                                    color: modelData
                                    radius: States.panelRounding

                                    border {
                                        width: 1
                                        color: Theme.bordercolor
                                    }

                                }

                            }

                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            ThemeState.themeIndex = model.index; 
                            States.themeOpen = false; 
                            ThemeState.saveTheme();
                            WallpaperState.randomWal();
                        }
                    }

                }

            }

        }

    }

}
