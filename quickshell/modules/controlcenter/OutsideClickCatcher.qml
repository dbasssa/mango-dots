import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.modules

// Fullscreen invisible window (one per screen) that closes the control
// center and notification center when clicked anywhere outside them.
// Needs a rendered (near-transparent) fullscreen rect to receive pointer
// input, otherwise mangowm gives it an empty input region.
PanelWindow {
    id: root

    required property var modelData

    screen: modelData
    color: "transparent"


    WlrLayershell.namespace: "quickshell:outside-click-catcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#01000000"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            States.ctrlOpen = false
        }
    }
}
