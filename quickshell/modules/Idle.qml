pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.services
import qs.modules

Singleton {
    id: root

    property bool hydrated: false
    property int lockMinutes: StateStore.get("idleLockMinutes", 0)
    property int sleepMinutes: StateStore.get("idleSleepMinutes", 0)
    property bool ignoreInhibitors: StateStore.get("idleIgnoreInhibitors", false)

    onLockMinutesChanged: if (root.hydrated)
        StateStore.set("idleLockMinutes", root.lockMinutes)
    onSleepMinutesChanged: if (root.hydrated)
        StateStore.set("idleSleepMinutes", root.sleepMinutes)
    onIgnoreInhibitorsChanged: if (root.hydrated)
        StateStore.set("idleIgnoreInhibitors", root.ignoreInhibitors)
    Component.onCompleted: root.hydrated = true

    IdleMonitor {
        id: lockMonitor

        enabled: root.lockMinutes > 0
        timeout: root.lockMinutes * 60
        respectInhibitors: !root.ignoreInhibitors

        onIsIdleChanged: {
            if (isIdle)
                States.lockScreen = true;
        }
    }

    Process {
        id: suspendProc

        command: ["systemctl", "suspend"]
        running: false
    }

    function statusText() {
        return "lock=" + root.lockMinutes + "min, sleep=" + root.sleepMinutes + "min, ignoreInhibitors=" + root.ignoreInhibitors + ", lockIdle=" + lockMonitor.isIdle + ", sleepIdle=" + sleepMonitor.isIdle;
    }

    //small control surface for testing and for keybind-driven changes
    IpcHandler {
        target: "idle-qs"

        function setLock(minutes: int) {
            root.lockMinutes = Math.max(0, Math.min(20, Math.floor(minutes)));
            console.log("idle-qs: " + root.statusText());
        }

        function setSleep(minutes: int) {
            root.sleepMinutes = Math.max(0, Math.min(20, Math.floor(minutes)));
            console.log("idle-qs: " + root.statusText());
        }

        function setIgnoreInhibitors(ignore: bool) {
            root.ignoreInhibitors = ignore;
            console.log("idle-qs: " + root.statusText());
        }

        function status() {
            console.log("idle-qs: " + root.statusText());
        }
    }
}
