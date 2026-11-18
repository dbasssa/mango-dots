import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import Quickshell.Wayland

import qs.modules
import qs.modules.themeing
import qs.services

Scope {
    id: root

    property bool showOsd: false
    //raised by brightness changes instead of volume changes
    property bool osdBrightness: false

    //show the osd and restart the hide countdown.
    //
    //this must run on *every* volume/brightness change, not just the first
    //one: holding a volume key emits changes faster than the hide timer, and
    //the old code only restarted the timer while the osd was hidden, so it
    //faded out mid-adjustment. see raise() below.
    function raise(brightness) {
        root.osdBrightness = brightness;

        //a change that lands during the fade-out should reverse it, not be
        //swallowed while the old animation keeps running
        osdFadeOut.stop();

        root.showOsd = true;
        hideTimer.restart();

        //only start a fade-in when one isn't already in flight, and continue
        //from the current opacity instead of snapping back to 0
        if (!osdFadeIn.running && osdWindow.osdOpacity < 1) {
            osdFadeIn.from = osdWindow.osdOpacity;
            osdFadeIn.restart();
        }
    }

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
            root.raise(false);
        }
    }

    //raise the osd when the brightness set on the audio/display page changes
    Connections {
        target: States

        function onBrightnessChanged() {
            root.raise(true);
        }
    }

    PanelWindow {
        id: osdWindow

        visible: root.showOsd
        anchors.bottom: true
        margins.bottom: 20
        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay

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
            easing.type: Easing.OutCubic
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

            //onFinished only fires when the fade actually completes, so
            //stopping it for a late volume change does not hide the window
            onFinished: root.showOsd = false
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
