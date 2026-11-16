import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules
import qs.modules.themeing
import qs.services

ColumnLayout {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 10

    Mpris {
        Layout.fillWidth: true
    }

    VolumeCtrl {
        Layout.fillWidth: true
    }

    //brightness slider
    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Text {
            Layout.fillWidth: false
            text: ""
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontbase
            }
            color: Theme.text1
        }

        Item {
            id: brightnessSlider

            Layout.fillWidth: true
            Layout.preferredHeight: 30

            property real value: 50
            property bool dragging: false
            property real dragBright: 50
            readonly property real displayBright: dragging ? dragBright : brightnessSlider.value

            readonly property real handleR: 8
            readonly property real trackX: handleR
            readonly property real trackW: Math.max(1, width - handleR * 2)
            //0 - 1 position of the brightness
            readonly property real ratio: Math.max(0, Math.min(1, displayBright / 100))
            readonly property real handleX: trackX + trackW * ratio

            function setFromX(x) {
                let r = (x - trackX) / trackW;
                r = Math.max(0, Math.min(1, r));
                dragBright = Math.round(r * 100);
            }

            //track
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                x: brightnessSlider.trackX
                width: brightnessSlider.trackW
                height: 5
                radius: 3
                color: Theme.rectcolor
            }

            //filled part
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                x: brightnessSlider.trackX
                width: Math.max(0, brightnessSlider.handleX - brightnessSlider.trackX)
                height: 5
                radius: 3
                color: Theme.textactive
            }

            //handle
            Rectangle {
                id: brightnessHandle
                anchors.verticalCenter: parent.verticalCenter
                x: brightnessSlider.handleX - width / 2
                width: 16
                height: 16
                radius: 8
                color: brightnessMouse.pressed || brightnessMouse.containsMouse ? Theme.textactive : Theme.text1
                border {
                    width: 2
                    color: Theme.bgcolor
                }
            }

            MouseArea {
                id: brightnessMouse
                anchors.fill: parent
                hoverEnabled: true
                //no usable backend (no internal backlight, no DDC/CI display)
                enabled: !Deps.probed || Deps.canSetBrightness
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                onPressed: {
                    brightnessSlider.dragging = true;
                    brightnessSlider.setFromX(mouseX);
                }
                onPositionChanged: {
                    if (brightnessMouse.pressed)
                        brightnessSlider.setFromX(mouseX);
                }
                onReleased: {
                    brightnessSlider.dragging = false;
                    brightnessSlider.value = brightnessSlider.dragBright;
                    const cmd = Deps.brightnessCommand(brightnessSlider.dragBright);
                    if (cmd.length === 0)
                        return;
                    brightnessProc.command = cmd;
                    brightnessProc.running = true;
                }
                onCanceled: brightnessSlider.dragging = false
            }
        }

        Text {
            id: brightnessText
            Layout.preferredWidth: 40
            Layout.alignment: Qt.AlignHCenter
            text: Deps.probed && !Deps.canSetBrightness ? "--" : Math.round(brightnessSlider.displayBright) + "%"
            color: Theme.text1
            horizontalAlignment: Text.AlignRight
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontbase
        }
    }

    Item {
        Layout.fillHeight: true
    }

    //set display brightness through whichever backend exists: brightnessctl
    //for an internal panel, ddcutil (VCP 10) for a DDC/CI monitor
    Process {
        id: brightnessProc
        command: []
        running: false
        stdout: StdioCollector {}
        onExited: {
            States.brightness = Math.round(brightnessSlider.value);
        }
    }
}
