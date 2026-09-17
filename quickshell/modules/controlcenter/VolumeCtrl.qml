import QtQuick
import QtQuick.Layouts
import Quickshell
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
    property bool outOpen: false

    function setVolume(posX) {
        if (!root.sinkReady)
            return
        const pct = Math.max(0, Math.min(1, posX / volbar.width))
        root.sink.audio.volume = pct
        if (pct > 0 && root.sink.audio.muted)
            root.sink.audio.muted = false
    }

    function showRows() {
        if (sinkList.count) {
            for (let i = 0; i < sinkList.count; i++) {
                const r = sinkList.itemAt(i);
                if (r)
                    r.show();
            }
        }
    }

    function hideRows() {
        if (sinkList.count) {
            for (let i = 0; i < sinkList.count; i++) {
                const r = sinkList.itemAt(i);
                if (r)
                    r.hide();
            }
        }
    }

    implicitHeight: col.implicitHeight
    Layout.fillWidth: true
    
    anchors.horizontalCenter: parent.horizontalCenter

    ColumnLayout {
        id: col
        anchors.fill: parent
        spacing: 10

        Rectangle {
            id: volbar
            Layout.preferredHeight: 50
            Layout.fillWidth: true
            radius: States.sliderRounding
            color: volMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
            

            border {
                width: States.borderOn ? 2 : 0
                color: Theme.bordercolor
            }

            Rectangle {
                id: volFill
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                anchors.margins: 2
                width: (parent.width - 4) * root.vol / 100
                radius: States.sliderRounding
                color: root.muted ? Theme.occupiedcolor : Theme.textactive
            }

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
                font.bold: true
            }

            MouseArea {
                id: volMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.setVolume(mouse.x)
                onPositionChanged: if (pressed) root.setVolume(mouse.x)
            }

        }

        RowLayout {
            Layout.preferredWidth: 350
            spacing: 10

            Rectangle {
                Layout.preferredHeight: 28
                Layout.preferredWidth: 52
                radius: States.sliderRounding
                color: micMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
                
                border.width: States.borderOn ? 1 : 0
                border.color: Theme.bordercolor

                Text {
                    anchors.centerIn: parent
                    text: root.micMuted ? "" : ""
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontlg
                    font.bold: true
color: root.micMuted ? Theme.alertcolor : Theme.miconcolor
                    scale: micMouse.containsMouse ? 1.15 : 1.0
                }

                MouseArea {
                    id: micMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (root.micReady)
                            root.mic.audio.muted = !root.micMuted;

                    }
                }

            }

            Rectangle {
                id: outchip
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                radius: States.sliderRounding
                color: outMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
                
                border.width: States.borderOn ? 2 : 0
                border.color: Theme.bordercolor

                RowLayout {
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    anchors.leftMargin: 10
                    anchors.rightMargin: 8
                    spacing: 6

                    Text {
                        Layout.fillWidth: true
                        text: root.sinkReady ? root.sink.description : "No output"
                        elide: Text.ElideRight
                        color: Theme.text1
                        font.family: Theme.fontfamily
                        font.pixelSize: Theme.fontmd
                    }

                    Text {
                        text: ""
color: root.outOpen ? Theme.textactive : Theme.textmuted
                        font.family: Theme.fontfamily
                        font.pixelSize: Theme.fontxs
                        rotation: root.outOpen ? 180 : 0
                    }
                }

                MouseArea {
                    id: outMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.outOpen = !root.outOpen
                }
            }

        }

        Repeater {
            id: sinkList
            model: ScriptModel {
                values: {
                    const nodes = Pipewire.nodes.values.filter(node => {
                        return node && node.audio && node.isSink && !node.isStream;
                    });
                    nodes.sort((a, b) => {
                        if (a === root.sink)
                            return -1;
                        if (b === root.sink)
                            return 1;
                        return 0;
                    });
                    return nodes;
                }
            }

            delegate: Rectangle {
                id: sinkrow
                required property var modelData
                required property int index
                Layout.fillWidth: true
                Layout.preferredHeight: 26
                visible: root.outOpen
                radius: States.sliderRounding
                color: sinkMouse.containsMouse ? Theme.bordercolor : (modelData === root.sink ? Theme.bordercolor : "transparent")
                
                opacity: 0
                transform: Translate { id: sinkRowT; y: -10 }

                Component.onCompleted: root.outOpen && sinkrow.show()

                function show() {
                    sinkrow.opacity = 1;
                    sinkRowT.y = 0;
                }

                function hide() {
                    sinkrow.opacity = 0;
                    sinkRowT.y = -10;
                }

                Text {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    anchors.leftMargin: 10
                    text: modelData.description
                    elide: Text.ElideRight
                    color: modelData === root.sink ? Theme.textactive : Theme.text1
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontmd
                    
                }

                MouseArea {
                    id: sinkMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        root.outOpen = false;
                        if (modelData)
                            Pipewire.preferredDefaultAudioSink = modelData;
                    }
                }
            }
        }

        PwObjectTracker {
            objects: [root.sink, root.mic]
        }

    }

    Connections {
        target: root
        function onOutOpenChanged() {
            if (root.outOpen)
                root.showRows();
            else
                root.hideRows();
        }
    }

    Connections {
        target: States
        function onCtrlOpenChanged() {
            if (!States.ctrlOpen)
                root.outOpen = false;
        }
    }

}
