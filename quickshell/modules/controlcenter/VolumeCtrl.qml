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
    implicitWidth: parent.implicitWidth
    anchors.horizontalCenter: parent.horizontalCenter

    ColumnLayout {
        id: col
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Rectangle {
            id: volbar
            Layout.preferredHeight: 50
            Layout.preferredWidth: 350
            radius: 5
            color: volMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
            Behavior on color { ColorAnimation { duration: 150 } }

            border {
                width: 2
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
                radius: 3
                color: root.muted ? Theme.occupiedcolor : Theme.textactive
                Behavior on width { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 200 } }
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
                Behavior on color { ColorAnimation { duration: 150 } }
                onTextChanged: voltxtPop.restart()
            }

            SequentialAnimation {
                id: voltxtPop
                NumberAnimation { target: voltxt; property: "scale"; from: 0.94; to: 1.04; duration: 110; easing.type: Easing.OutCubic }
                NumberAnimation { target: voltxt; property: "scale"; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
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
                radius: 5
                color: micMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
                Behavior on color { ColorAnimation { duration: 150 } }
                border.width: 1
                border.color: Theme.bordercolor

                Text {
                    anchors.centerIn: parent
                    text: root.micMuted ? "" : ""
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontlg
                    font.bold: true
                    color: root.micMuted ? Theme.alertcolor : Theme.miconcolor
                    Behavior on color { ColorAnimation { duration: 150 } }
                    scale: micMouse.containsMouse ? 1.15 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
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
                radius: 5
                color: outMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
                Behavior on color { ColorAnimation { duration: 150 } }
                border.width: 1
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
                        Behavior on rotation { NumberAnimation { duration: 220; easing.type: Easing.InOutCubic } }
                        Behavior on color { ColorAnimation { duration: 150 } }
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
                radius: 4
                color: sinkMouse.containsMouse ? Theme.bordercolor : (modelData === root.sink ? Theme.bordercolor : "transparent")
                Behavior on color { ColorAnimation { duration: 150 } }
                opacity: 0
                transform: Translate { id: sinkRowT; y: -10 }

                Component.onCompleted: root.outOpen && sinkrow.show()

                function show() {
                    sinkRowAnim.restart();
                }

                function hide() {
                    sinkRowAnim.stop();
                    sinkrow.opacity = 0;
                    sinkRowT.y = -10;
                }

                SequentialAnimation {
                    id: sinkRowAnim
                    PauseAnimation { duration: sinkrow.index * 45 }
                    ParallelAnimation {
                        NumberAnimation { target: sinkrow; property: "opacity"; to: 1; duration: 180; easing.type: Easing.OutCubic }
                        NumberAnimation { target: sinkRowT; property: "y"; to: 0; duration: 220; easing.type: Easing.OutCubic }
                    }
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
                    Behavior on color { ColorAnimation { duration: 150 } }
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
