pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Region screenshots through grim + slurp.
//
// The shell command saves a timestamped PNG under ~/Pictures/Screenshots and
// copies it to the clipboard when wl-copy is available. Cancelling slurp is
// treated as a normal no-op.
Singleton {
    id: root

    property bool active: false
    property string lastPath: ""
    property string lastError: ""

    function region() {
        if (grabProc.running)
            return;
        root.active = true;
        root.lastError = "";
        grabProc.running = true;
    }

    Process {
        id: grabProc

        command: ["sh", "-c",
            "command -v grim >/dev/null 2>&1 && command -v slurp >/dev/null 2>&1 || exit 127; "
            + "dir=\"$HOME/Pictures/Screenshots\"; mkdir -p \"$dir\" || exit 1; "
            + "geom=$(slurp) || exit 0; [ -n \"$geom\" ] || exit 0; "
            + "out=\"$dir/$(date +%Y-%m-%d_%H-%M-%S).png\"; "
            + "grim -g \"$geom\" \"$out\" || exit 1; "
            + "if command -v wl-copy >/dev/null 2>&1; then wl-copy < \"$out\"; fi; "
            + "printf '%s' \"$out\""]
        running: false
        stdout: StdioCollector {}

        onExited: (code, status) => {
            root.active = false;
            const out = stdout.text.trim();
            if (code === 0 && out !== "") {
                root.lastPath = out;
            } else if (code === 127) {
                root.lastError = "grim and slurp are required";
            } else if (code !== 0) {
                root.lastError = "Screenshot failed";
            }
        }
    }

    IpcHandler {
        function region() {
            root.region();
        }

        target: "screenshot-qs"
    }
}
