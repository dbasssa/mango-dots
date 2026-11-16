import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts

import qs.modules
import qs.modules.themeing
import qs.services

Scope {
    id: root

    property bool showOsd: false
    //raised by brightness changes instead of volume changes
    property bool osdBrightness: false

    Timer {
        id: hideTimer
        interval: States.timerLength
        running: root.showOsd
        onTriggered: {
            osdFadeOut.restart();
        }
    }

    Connections {
        target: Pipewire.sinkReady ? Pipewire.sink.audio : null

        function onVolumesChanged() {
            root.osdBrightness = false;
            if (!root.showOsd) {
                root.showOsd = true;
                hideTimer.restart();
                osdFadeIn.restart();
            }
        }
    }

    //raise the osd when the brightness set on the audio/display page changes
    Connections {
        target: States

        function onBrightnessChanged() {
            root.osdBrightness = true;
            if (!root.showOsd) {
                root.showOsd = true;
                hideTimer.restart();
                osdFadeIn.restart();
            }
        }
    }

    PanelWindow {
        id: osdWindow

        visible: root.showOsd
        anchors.bottom: true
        margins.bottom: 20
        exclusiveZone: 0

        implicitWidth: 400
        implicitHeight: 50
        color: "transparent"

        mask: Region {}

        //fade amount for the osd open/close animation (0..1)
        property real osdOpacity: 0

        //fade the osd in and out
        NumberAnimation {
            id: osdFadeIn
            target: osdWindow
            property: "osdOpacity"
            from: 0
            to: 1
            duration: 300
            running: false
        }

        NumberAnimation {
            id: osdFadeOut
            target: osdWindow
            property: "osdOpacity"
            from: 1
            to: 0
            duration: 300
            easing.type: Easing.OutCubic
            running: false
            onRunningChanged: {
                if (!running) {
                    //fade finished — hide the osd until it is raised again
                    root.showOsd = false;
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            opacity: osdWindow.osdOpacity
            radius: States.itemRounding
            color: Theme.bgcolor
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 10
                    color: Theme.textmuted
                    radius: States.itemRounding

                    Rectangle {
                        anchors.left: parent.left
                        implicitHeight: 10
                        implicitWidth: (root.osdBrightness ? States.brightness : Pipewire.vol) < 100 ? parent.width * ((root.osdBrightness ? States.brightness : Pipewire.vol) / 100) : parent.width
                        color: Theme.text1
                        radius: States.itemRounding
                    }
                }
                Text {
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontlg
                    }
                    text: (root.osdBrightness ? States.brightness + " " : Pipewire.vol + " 󰕾")
                }
            }
        }
    }
}
