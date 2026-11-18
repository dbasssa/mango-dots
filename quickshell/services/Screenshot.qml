pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Region screenshots through grim + slurp.
//
// The shell command saves a timestamped PNG under ~/Pictures/Screenshots and
// copies it to the clipboard when wl-copy is available. Cancelling slurp is
// treated as a normal no-op.
//
// slurp itself draws only a crosshair, so without a hint the trigger looks like
// it did nothing. A short notification announces the selection step and another
// confirms the saved file, which also makes failures visible.
//
// slurp 1.5 reads stdin to EOF before mapping its overlay. Quickshell gives
// child processes an open pipe on stdin, so without </dev/null slurp blocks
// before ever connecting to Wayland: no overlay, no crosshair, no selection.
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
            + "if command -v notify-send >/dev/null 2>&1; then "
            + "notify-send -a Screenshot -t 1500 \"Select a region\" \"Drag to capture · Esc to cancel\" || true; fi; "
            + "geom=$(slurp </dev/null) || exit 0; [ -n \"$geom\" ] || exit 0; "
            + "out=\"$dir/$(date +%Y-%m-%d_%H-%M-%S).png\"; "
            + "grim -g \"$geom\" \"$out\" || exit 1; "
            + "if command -v wl-copy >/dev/null 2>&1; then wl-copy < \"$out\"; fi; "
            //saved notification carries a 'default' action; the card body click
            //invokes it, notify-send prints the key and we open the folder with
            //xdg-open. run detached with --wait so the selection process can
            //finish and a later screenshot is not blocked by a pending click.
            + "if command -v notify-send >/dev/null 2>&1; then "
            + "( key=$(notify-send --wait --action=default=\"Open folder\" -a Screenshot \"Screenshot saved\" \"$(basename \"$out\")\"); "
            + "if [ \"$key\" = \"default\" ]; then xdg-open \"$dir\" >/dev/null 2>&1; fi ) "
            + "</dev/null >/dev/null 2>&1 & fi; "
            + "printf '%s' \"$out\""]
        running: false
        stdout: StdioCollector {}
        stderr: StdioCollector {}

        onExited: (code, status) => {
            root.active = false;
            const out = stdout.text.trim();
            if (code === 0 && out !== "") {
                root.lastPath = out;
            } else if (code === 127) {
                root.lastError = "grim and slurp are required";
            } else if (code !== 0) {
                root.lastError = "Screenshot failed";
                const err = stderr.text.trim();
                if (err !== "")
                    console.warn("screenshot: " + err);
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
