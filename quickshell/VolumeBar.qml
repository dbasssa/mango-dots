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
    implicitWidth: 60
    anchors.verticalCenter: parent.verticalCenter

    RowLayout {
        id:rwolyt
        anchors.fill: parent
        spacing: 2

        Rectangle {
            Layout.preferredHeight:28
            Layout.preferredWidth: 52
            Layout.alignment:Qt.AlignVCenter
            radius:5
            color: volMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
            Behavior on color { ColorAnimation { duration: 150 } }
            border{
                width:1
                color: Theme.bordercolor
            }
            scale: volMouse.containsMouse ? 1.1 : 1.0
            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Text {
                id:voltxt
                anchors.centerIn:parent
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
                Behavior on color { ColorAnimation { duration: 150 } }
                onTextChanged: volPop.restart()
            }

            SequentialAnimation {
                id: volPop
                NumberAnimation { target: voltxt; property: "scale"; from: 0.9; to: 1.04; duration: 110; easing.type: Easing.OutCubic }
                NumberAnimation { target: voltxt; property: "scale"; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
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

}
