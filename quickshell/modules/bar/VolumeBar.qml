import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

import qs.modules
import qs.modules.themeing

Item {
    id: root

    property var sink: Pipewire.defaultAudioSink
    property var mic: Pipewire.defaultAudioSource
    readonly property bool sinkReady: sink && sink.ready
    readonly property bool muted: sinkReady && sink.audio.muted
    readonly property int vol: sinkReady ? Math.round(sink.audio.volume * 100) : 0
    readonly property bool micReady: mic && mic.ready
    readonly property bool micMuted: micReady && mic.audio.muted

    implicitHeight: parent.implicitHeight - 5
    implicitWidth: voltxt.implicitWidth + 10
    anchors.verticalCenter: parent.verticalCenter

        Text {
            id: voltxt

            anchors.centerIn: parent
            text: {
                if (!root.sinkReady)
                    return "-";

                if (root.muted)
                    return "0%";

                return root.vol + "% 󰕾";
            }
            color: root.muted ? Theme.textmuted : Theme.text1
            font.family: Theme.fontfamily
            font.pixelSize: Theme.fontlg * States.fontScale
        }



    PwObjectTracker {
        objects: [root.sink]
    }


}
