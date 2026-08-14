import QtQuick
import Quickshell
import Quickshell.Io

Row {
    id: root

    // Output name of the screen this bar is on (e.g. "DP-3"), matched against
    // the `monitor` field in `mmsg watch all-tags`. Set from shell.qml via
    // screen.name. Falls back to monitor index 0 when unset or unmatched.
    property string monitorName: ""
    // Monitor index of the bar's screen (derived from monitorName). Used for
    // mmsg dispatch.
    property int monitorIndex: 0
    // Latest tag state for this monitor:
    //   tags[i] = { index, is_active, is_urgent, layout, client_count }
    property var tags: []
    // Raw latest payload (all monitors) if you need it elsewhere
    property var monitors: []
    property var getHandler: null

    // Emitted once per tag event with the raw payload
    signal tagsUpdated(var payload)

    // One-shot dispatch: switch tag, move window to tag, etc.
    //   dispatch("view", [tagIndex, monitorIndex])   switch to tag
    //   dispatch("tag",  [tagIndex, monitorIndex])   move focused window to tag
    function dispatch(fn, args) {
        dispProc.command = ["mmsg", "dispatch", fn].concat(args ?? []);
        dispProc.running = false;
        dispProc.running = true;
    }

    // One-shot query, e.g. refresh(["all-monitors"], cb)
    function refresh(cmd, onData) {
        getProc.command = ["mmsg", "get"].concat(cmd);
        getHandler = onData;
        getProc.running = false;
        getProc.running = true;
    }

    spacing: 5
    Component.onDestruction: tagStream.running = false

    // --- IPC ---
    // Persistent stream: one full JSON line per tag/monitor change
    Process {
        id: tagStream

        command: ["mmsg", "watch", "all-tags"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                try {
                    let j = JSON.parse(data);
                    root.monitors = j.all_tags;
                    let idx = 0;
                    if (root.monitorName) {
                        idx = j.all_tags.findIndex((b) => {
                            return b.monitor === root.monitorName;
                        });
                        if (idx < 0)
                            idx = 0;

                    }
                    root.monitorIndex = idx;
                    let block = j.all_tags[idx];
                    root.tags = block ? block.tags : [];
                    root.tagsUpdated(j);
                } catch (e) {
                    console.warn("Workspaces: bad mmsg payload", e);
                }
            }
        }

    }

    Process {
        id: dispProc

        command: ["mmsg", "get", "version"]
        running: false
    }

    Process {
        id: getProc

        running: false

        stdout: SplitParser {
            onRead: (data) => {
                if (data) {
                    try {
                        root.getHandler(JSON.parse(data));
                    } catch (e) {
                    }
                }
            }
        }

    }

    // --- UI ---
    Repeater {
        id: wsRepeater

        model: root.tags

        delegate: Rectangle {
            id: pill

            required property var modelData
            property bool hovered: false

            width: modelData.is_active ? 28 : (pill.hovered ? 20 : 15)
            height: 15
            radius: 8
            color: modelData.is_urgent ? Theme.alertcolor : Theme.textactive
            border.color: modelData.is_active ? Theme.wsbordercolor : Theme.bgcolor
            border.width: (modelData.is_active || pill.hovered) ? 2 : 0
            scale: pill.hovered ? 1.15 : 1.0

            Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on border.width { NumberAnimation { duration: 150 } }
            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: pill.hovered = true
                onExited: pill.hovered = false
                onClicked: root.dispatch("view", [modelData.index, root.monitorIndex])
            }

        }

    }

}
