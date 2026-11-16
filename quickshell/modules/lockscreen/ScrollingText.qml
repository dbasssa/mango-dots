import QtQuick

import qs.modules.themeing

//single-line text that slides back and forth when it doesn't fit
Item {
    id: root

    property string text: ""
    property color color: Theme.text1
    property int pixelSize: Theme.fontmd
    property bool bold: false
    property string fontFamily: Theme.fontfamily
    property int pause: 1800

    readonly property bool overflowing: label.implicitWidth > root.width
    readonly property real travel: Math.max(0, label.implicitWidth - root.width)
    readonly property int scrollDuration: Math.max(2500, Math.round(root.travel * 1000 / 35))

    implicitHeight: label.implicitHeight
    implicitWidth: label.implicitWidth
    clip: true

    Text {
        id: label

        text: root.text
        color: root.color
        x: 0

        font {
            family: root.fontFamily
            pixelSize: root.pixelSize
            bold: root.bold
        }
    }

    SequentialAnimation {
        id: marquee

        running: root.visible && root.overflowing && root.text !== ""
        loops: Animation.Infinite

        PauseAnimation {
            duration: root.pause
        }

        NumberAnimation {
            target: label
            property: "x"
            to: -root.travel
            duration: root.scrollDuration
            easing.type: Easing.InOutQuad
        }

        PauseAnimation {
            duration: root.pause
        }

        NumberAnimation {
            target: label
            property: "x"
            to: 0
            duration: root.scrollDuration
            easing.type: Easing.InOutQuad
        }
    }

    onOverflowingChanged: {
        if (!root.overflowing)
            label.x = 0;
    }

    onTextChanged: {
        label.x = 0;
    }

    onVisibleChanged: {
        if (!root.visible)
            label.x = 0;
    }
}
