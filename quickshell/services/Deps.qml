pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Runtime tool availability.
//
// install.sh brings the required packages in, but brightness is
// hardware-dependent: a laptop exposes a backlight through brightnessctl while
// an external monitor is driven over DDC/CI with ddcutil, and a machine may
// have neither. Probing once at startup lets the UI disable the slider instead
// of silently doing nothing when the backend is missing.
Singleton {
    id: root

    property bool probed: false
    // only a real panel backlight counts: `brightnessctl -m` also succeeds for
    // keyboard/LAN LEDs, which must not be driven by the display slider
    property bool hasBacklight: false
    property bool hasDdcutil: false
    // /dev/i2c-N of the first DDC/CI display, empty when none was detected
    property string ddcBus: ""

    readonly property bool canSetBrightness: root.hasBacklight || root.hasDdcutil
    readonly property string brightnessBackend: root.hasBacklight ? "brightnessctl" : (root.hasDdcutil ? "ddcutil" : "")

    function brightnessCommand(percent) {
        const p = Math.max(0, Math.min(100, Math.round(percent)));
        if (root.hasBacklight)
            return ["brightnessctl", "--class=backlight", "set", p + "%"];
        if (root.hasDdcutil) {
            //prefer the detected bus, but ddcutil's default display also works
            if (root.ddcBus !== "")
                return ["ddcutil", "-b", root.ddcBus, "setvcp", "10", String(p)];
            return ["ddcutil", "setvcp", "10", String(p)];
        }
        return [];
    }

    Process {
        id: probe

        //one capability per line; trailing `true` keeps the exit status clean.
        //ddcutil only counts when a display actually answered: the package is
        //installed unconditionally, but a machine without a DDC/CI monitor must
        //not enable the slider.
        command: ["sh", "-c",
            "if brightnessctl --class=backlight -m >/dev/null 2>&1; then echo brightnessctl; fi; "
            + "bus=$(ddcutil detect --brief 2>/dev/null | sed -n 's|.*/dev/i2c-\\([0-9][0-9]*\\).*|\\1|p' | head -n1); "
            + "[ -n \"$bus\" ] && echo \"bus:$bus\"; true"]
        running: true
        stdout: StdioCollector {}

        onExited: {
            const lines = stdout.text.trim().split("\n");
            root.hasBacklight = lines.indexOf("brightnessctl") !== -1;
            for (let i = 0; i < lines.length; i++) {
                if (lines[i].startsWith("bus:")) {
                    root.ddcBus = lines[i].substring(4);
                    break;
                }
            }
            root.hasDdcutil = root.ddcBus !== "";
            root.probed = true;
        }
    }
}
