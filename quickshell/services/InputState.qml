pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

//small input/mode states that don't come from another singleton:
//caps lock comes from the keyboard LEDs; layout and keymode come from the
//shared mmsg watchers in services/Mmsg.qml.
Singleton {
    id: root

    property bool capsLock: false
    property string layout: Mmsg.layout
    property string keymode: Mmsg.keymode

    //"English (US)" -> "US"; leave unnamed layouts untouched
    readonly property string layoutLabel: {
        if (root.layout === "")
            return "";
        const match = root.layout.match(/\(([^)]+)\)/);
        return match ? match[1] : root.layout;
    }

    //there is no portable wayland protocol for lock-key state, so poll the
    //keyboard LEDs (the usual fallback used by wayland bars)
    Process {
        command: ["sh", "-c", "while :; do v=0; for f in /sys/class/leds/*::capslock/brightness; do if [ -r \"$f\" ] && [ \"$(cat \"$f\")\" = \"1\" ]; then v=1; fi; done; echo $v; sleep 0.1; done"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => root.capsLock = String(data).trim() === "1"
        }
    }

}
