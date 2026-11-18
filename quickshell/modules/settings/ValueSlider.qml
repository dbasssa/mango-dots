import QtQuick
import qs.modules
import qs.modules.themeing

// Shared slider used by the settings pages.
//
// Emits moved() continuously while dragging (so live values like volume update
// as you drag) and committed() on release (so expensive actions such as
// spawning a brightness process only run once).
Item {
    id: root

    property real from: 0
    property real to: 100
    property real value: 0

    signal moved(real value)
    signal committed(real value)

    property bool dragging: false
    property real dragValue: 0

    readonly property real displayValue: root.dragging ? root.dragValue : root.value
    readonly property real handleR: 8
    readonly property real trackX: handleR
    readonly property real trackW: Math.max(1, width - handleR * 2)
    readonly property real ratio: root.to > root.from ? Math.max(0, Math.min(1, (root.displayValue - root.from) / (root.to - root.from))) : 0
    readonly property real handleX: trackX + trackW * ratio

    implicitHeight: 30
    opacity: enabled ? 1 : 0.4

    function valueFromX(x) {
        let r = (x - root.trackX) / root.trackW;
        r = Math.max(0, Math.min(1, r));
        return Math.round(root.from + r * (root.to - root.from));
    }

    //track
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: root.trackX
        width: root.trackW
        height: 5
        radius: 3
        color: Theme.rectcolor
    }

    //filled part
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: root.trackX
        width: Math.max(0, root.handleX - root.trackX)
        height: 5
        radius: 3
        color: Theme.textactive
    }

    //handle
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: root.handleX - width / 2
        width: 16
        height: 16
        radius: 8
        color: rootMouse.pressed || rootMouse.containsMouse ? Theme.textactive : Theme.text1

        border {
            width: 2
            color: Theme.bgcolor
        }
    }

    MouseArea {
        id: rootMouse

        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor

        onPressed: {
            root.dragging = true;
            root.dragValue = root.valueFromX(mouseX);
            root.moved(root.dragValue);
        }
        onPositionChanged: {
            if (!pressed)
                return;
            const v = root.valueFromX(mouseX);
            if (v !== root.dragValue) {
                root.dragValue = v;
                root.moved(v);
            }
        }
        onReleased: {
            root.dragging = false;
            root.committed(root.dragValue);
        }
        onCanceled: {
            root.dragging = false;
            root.committed(root.dragValue);
        }
        onWheel: (wheel) => {
            if (wheel.angleDelta.y === 0)
                return;
            const delta = wheel.angleDelta.y > 0 ? 5 : -5;
            const v = Math.max(root.from, Math.min(root.to, Math.round(root.value + delta)));
            root.moved(v);
            root.committed(v);
        }
    }
}
