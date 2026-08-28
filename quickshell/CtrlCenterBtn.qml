import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

Rectangle {
    id: root
    visible: States.notchBar ? false : true
    Layout.alignment: Qt.AlignVCenter
    implicitHeight: 28
    implicitWidth: btnRow.implicitWidth + 24
    color: ctrlMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
    Behavior on color { ColorAnimation { duration: 150 } }
    radius: 5

    border {
        width: 1
        color: Theme.bordercolor
    }

    scale: ctrlMouse.containsMouse ? 1.1 : 1.0
    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

    property var sink: Pipewire.defaultAudioSink
    readonly property bool sinkReady: sink && sink.ready
    readonly property bool muted: sinkReady && sink.audio.muted
    readonly property int vol: sinkReady ? Math.round(sink.audio.volume * 100) : 0

    RowLayout {
        id: btnRow
        anchors.centerIn: parent
        spacing: 0

        Text {
            text: root.muted ? "" : ""
            color: root.muted ? Theme.textmuted : Theme.text1
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontxl
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        Text {
            text: " | "
            color: Theme.bordercolor
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontxxl
        }

        Text {
            text: ""
            color: Theme.text1
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontxxl
        }        

        Text {
            text: " | "
            color: Theme.bordercolor
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontxxl
        }

        Text {
            text: "󰍜"
            color: States.ctrlOpen ? Theme.textactive : Theme.text1
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontxxl
            rotation: States.ctrlOpen ? 90 : 0
            Behavior on rotation { NumberAnimation { duration: 350; easing.type: Easing.InOutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: ctrlMouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {States.ctrlOpen = !States.ctrlOpen; States.appOpen = false}
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}
