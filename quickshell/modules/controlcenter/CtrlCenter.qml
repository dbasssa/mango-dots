import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

import qs.modules
import qs.modules.themeing

PanelWindow {
    id: root

    property bool animOpen: false

    exclusionMode: ExclusionMode.Ignore
    visible: animOpen
    implicitHeight: centerCol.implicitHeight + 10
    implicitWidth: 380
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
        top: true
        right: States.fullBar ? true : false
    }

    margins {
        top: States.frameVis ? 53 : 50
        right: States.fullBar ? 12 : 0
    }
    IpcHandler {
        target: "ctrlcntr-qs"
        function toggle() {
            States.ctrlOpen = !States.ctrlOpen
        }
    }

    Connections {
        function onCtrlOpenChanged() {
            if (States.ctrlOpen) {
                root.animOpen = true;
                Qt.callLater(panelIn.start);
            } else {
                panelOut.start();
            }
        }

        target: States
    }

    Rectangle {
        id: panelBody

        anchors.fill: parent
        color: Theme.rectcolor
        radius: States.frameRounding
        opacity: 0
        scale: 0.97

        border {
            width: 2
            color: Theme.bordercolor
        }

        ColumnLayout {
            id: centerCol

            anchors.fill: parent
            anchors.centerIn: parent
            anchors.topMargin: 12
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 10

            Text {
                text: "Audio Ctrls =========================================="
                color: Theme.textmuted

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontmd
                }

            }

            Mpris {
            }

            VolumeCtrl {
            }

            Text {
                text: "Brightness =========================================="
                color: Theme.textmuted

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontmd
                }

            }

            BrightnessCtl {
            }

            Text {
                text: "Theme ==============================================="
                color: Theme.textmuted

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontmd
                }

            }

            WallBtn {
            }

            Item {
                Layout.preferredHeight: 40
                Layout.preferredWidth: 350

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: themeBtn.containsMouse ? Theme.recthovercolor : Theme.rectcolor

                    border {
                        color: Theme.bordercolor
                        width: 1
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Themes"
                        color: Theme.text1

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontmd
                        }

                    }

                }

                MouseArea {
                    id: themeBtn

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        States.ctrlOpen = false;
                        States.themePickerOpen = true;
                    }
                }

            }

            Text {
                text: "System =============================================="
                color: Theme.textmuted

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontmd
                }

            }

            LogoutMenu {
            }

            

            Item {
                Layout.fillHeight: true
            }

        }

        transform: Translate {
            id: panelT

            y: -14
        }

    }

    ParallelAnimation {
        id: panelIn

        NumberAnimation {
            target: panelBody
            property: "opacity"
            to: 1
            duration: 200
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: panelT
            property: "y"
            to: 0
            duration: 240
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: panelBody
            property: "scale"
            to: 1
            duration: 200
            easing.type: Easing.OutCubic
        }

    }

    SequentialAnimation {
        id: panelOut

        ParallelAnimation {
            NumberAnimation {
                target: panelBody
                property: "opacity"
                to: 0
                duration: 150
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: panelT
                property: "y"
                to: -14
                duration: 170
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: panelBody
                property: "scale"
                to: 0.97
                duration: 150
                easing.type: Easing.InCubic
            }

        }

        ScriptAction {
            script: root.animOpen = false
        }

    }

}
