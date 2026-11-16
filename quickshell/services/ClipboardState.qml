pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

//clipboard history backed by cliphist (wl-clipboard's database).
//the watcher stores every clipboard change, so history survives shell
//reloads and reboots without keeping the contents in state.json.
Singleton {
    id: root

    //newest first; { id, preview }
    property var entries: []

    //cap the UI list — the database itself is capped by cliphist
    readonly property int maxEntries: 100

    function refresh() {
        if (!listProc.running)
            listProc.running = true;
    }

    //copy an entry back to the clipboard and close the overlay
    function copy(id) {
        const safeId = parseInt(id);
        if (isNaN(safeId))
            return;
        copyProc.command = ["sh", "-c", "cliphist decode " + safeId + " | wl-copy"];
        copyProc.running = true;
    }

    function clear() {
        if (!wipeProc.running)
            wipeProc.running = true;
    }

    //record clipboard changes; the pgrep guard keeps reloads from spawning
    //duplicate watchers (match on the wl-paste process's own argv, not the
    //sh -c wrapper, which would otherwise match itself forever)
    Process {
        id: watcher
        command: ["sh", "-c", "pgrep -x wl-paste -a 2>/dev/null | grep -q \"cliphist store\" || exec wl-paste --watch cliphist store"]
        running: true
    }

    Process {
        id: listProc
        command: ["cliphist", "list"]
        running: false
        stdout: StdioCollector {}
        onExited: {
            const text = stdout.text.trim();
            if (text === "") {
                root.entries = [];
                return;
            }
            const lines = text.split("\n");
            const out = [];
            for (let i = 0; i < lines.length && out.length < root.maxEntries; i++) {
                const tab = lines[i].indexOf("\t");
                if (tab <= 0)
                    continue;
                const id = parseInt(lines[i].substring(0, tab));
                if (isNaN(id))
                    continue;
                out.push({
                    id: id,
                    preview: lines[i].substring(tab + 1)
                });
            }
            root.entries = out;
        }
    }

    Process {
        id: copyProc
        running: false
    }

    Process {
        id: wipeProc
        command: ["cliphist", "wipe"]
        running: false
        onExited: root.refresh()
    }

    Component.onCompleted: root.refresh()
}
