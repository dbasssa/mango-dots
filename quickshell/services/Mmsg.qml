pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Single owner for every mmsg event stream.
//
// MangoWM exposes state through `mmsg watch <type>`, which is a persistent
// process. Keeping the watchers here means one process per stream no matter
// how many widgets read the value, and every consumer sees the same parsed
// state instead of racing its own watcher.
Singleton {
    id: root

    //focused window, as reported by `mmsg watch focusing-client`
    property string focusedApp: ""
    property string focusedTitle: ""

    //keyboard state, as reported by `mmsg watch keyboardlayout`/`keymode`
    property string layout: ""
    property string keymode: ""

    //monitor name -> tags array from `mmsg watch tags <monitor>`
    property var tagsByMonitor: ({})

    //"English (US)" -> "US"; leave unnamed layouts untouched
    readonly property string layoutLabel: {
        if (root.layout === "")
            return "";
        const match = root.layout.match(/\(([^)]+)\)/);
        return match ? match[1] : root.layout;
    }

    function tags(monitor) {
        return root.tagsByMonitor[monitor] ?? [];
    }

    //view a tag on a specific monitor, regardless of which monitor is focused.
    //`view,<tag>,0` only ever acts on the focused monitor, so clicking a
    //workspace chip on another screen would switch the wrong display.
    function dispatchView(tag, monitor) {
        if (monitor)
            dispatchProc.command = ["mmsg", "dispatch", "viewcrossmon," + tag + "," + monitor];
        else
            dispatchProc.command = ["mmsg", "dispatch", "view," + tag + ",0"];
        dispatchProc.running = true;
    }

    function parseEvent(data) {
        const line = String(data).trim();
        if (line === "")
            return null;
        try {
            return JSON.parse(line);
        } catch (e) {
            return null;
        }
    }

    Process {
        command: ["mmsg", "watch", "focusing-client"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const obj = root.parseEvent(data);
                if (!obj)
                    return;
                if (obj.appid !== undefined) {
                    root.focusedApp = obj.appid === "" ? "Desktop" : obj.appid;
                    if (obj.appid === "")
                        root.focusedTitle = "";
                }
                if (obj.title !== undefined)
                    root.focusedTitle = obj.title === "" ? "Desktop" : obj.title;
            }
        }
    }

    Process {
        command: ["mmsg", "watch", "keyboardlayout"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const obj = root.parseEvent(data);
                if (obj && obj.layout !== undefined)
                    root.layout = obj.layout;
            }
        }
    }

    Process {
        command: ["mmsg", "watch", "keymode"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const obj = root.parseEvent(data);
                if (obj && obj.keymode !== undefined)
                    root.keymode = obj.keymode;
            }
        }
    }

    //tags are per-monitor, so one watcher is created for every screen and
    //removed/added as screens come and go
    Instantiator {
        model: Quickshell.screens

        delegate: Process {
            command: ["mmsg", "watch", "tags", modelData.name]
            running: true

            stdout: SplitParser {
                splitMarker: "\n"
                onRead: data => {
                    const obj = root.parseEvent(data);
                    if (!obj || !obj.tags)
                        return;
                    const next = Object.assign({}, root.tagsByMonitor);
                    next[modelData.name] = obj.tags;
                    root.tagsByMonitor = next;
                }
            }
        }
    }

    Process {
        id: dispatchProc
        command: []
        running: false
    }
}
