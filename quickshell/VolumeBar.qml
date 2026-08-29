import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Item {
    id: root

    property var sink: Pipewire.defaultAudioSink
    property var mic: Pipewire.defaultAudioSource
    readonly property bool sinkReady: sink && sink.ready
    readonly property bool muted: sinkReady && sink.audio.muted
    readonly property int vol: sinkReady ? Math.round(sink.audio.volume * 100) : 0
    readonly property bool micReady: mic && mic.ready
    readonly property bool micMuted: micReady && mic.audio.muted

    implicitHeight: 40
    implicitWidth: voltxt.implicitWidth +5
    anchors.verticalCenter: parent.verticalCenter

    RowLayout {
        id: rwolyt

        anchors.fill: parent
        spacing: 2

        Text {
            id: voltxt

            anchors.centerIn: parent
            text: {
                if (!root.sinkReady)
                    return "-";

                if (root.muted)
                    return "0%";

                return root.vol + "%";
            }
            color: root.muted ? Theme.textmuted : Theme.text1
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontlg
            onTextChanged: volPop.restart()

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }

            }

        }

        SequentialAnimation {
            id: volPop

            NumberAnimation {
                target: voltxt
                property: "scale"
                from: 0.9
                to: 1.04
                duration: 110
                easing.type: Easing.OutCubic
            }

            NumberAnimation {
                target: voltxt
                property: "scale"
                to: 1
                duration: 180
                easing.type: Easing.OutCubic
            }

        }

        MouseArea {
            id: volMouse

            anchors.fill: parent
            hoverEnabled: true
        }

    }

    PwObjectTracker {
        objects: [root.sink]
    }

    Process {
        id: volumeLauncher

        command: ["pavucontrol"]
    }

}
