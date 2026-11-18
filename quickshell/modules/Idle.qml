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

    readonly property bool lockEnabled: root.lockMinutes > 0
    readonly property bool sleepEnabled: root.sleepMinutes > 0
    readonly property bool timersEnabled: root.lockEnabled || root.sleepEnabled

    //the single idle monitor fires at the earliest enabled threshold and hands
    //the remaining wait over to suspendTimer, which replaces the old second
    //IdleMonitor (two monitors did not work reliably)
    readonly property int firstMinutes: {
        if (root.lockEnabled && root.sleepEnabled)
            return Math.min(root.lockMinutes, root.sleepMinutes);
        return root.lockEnabled ? root.lockMinutes : root.sleepMinutes;
    }
    readonly property int suspendDelayMinutes: Math.max(0, root.sleepMinutes - root.firstMinutes)

    onLockMinutesChanged: if (root.hydrated)
        StateStore.set("idleLockMinutes", root.lockMinutes)
    onSleepMinutesChanged: {
        if (root.hydrated)
            StateStore.set("idleSleepMinutes", root.sleepMinutes);
        if (root.hydrated && idleMonitor.isIdle)
            root.armSuspendTimer();
    }
    onIgnoreInhibitorsChanged: if (root.hydrated)
        StateStore.set("idleIgnoreInhibitors", root.ignoreInhibitors)
    Component.onCompleted: root.hydrated = true

    function armSuspendTimer() {
        suspendTimer.stop();
        if (!root.sleepEnabled)
            return;
        suspendTimer.interval = root.suspendDelayMinutes * 60000;
        suspendTimer.restart();
    }

    IdleMonitor {
        id: idleMonitor

        enabled: root.timersEnabled
        timeout: root.firstMinutes * 60
        respectInhibitors: !root.ignoreInhibitors

        onIsIdleChanged: {
            if (!isIdle) {
                suspendTimer.stop();
                return;
            }

            //lock only once its own threshold has been reached; if suspend is
            //the earlier action the machine goes down first, like the old
            //two-monitor setup
            if (root.lockEnabled && root.lockMinutes <= root.firstMinutes)
                States.lockScreen = true;

            root.armSuspendTimer();
        }
    }

    Timer {
        id: suspendTimer

        repeat: false
        onTriggered: {
            if (root.sleepEnabled && idleMonitor.isIdle) {
                console.log("idle-qs: suspending after " + root.firstMinutes + "min idle");
                suspendProc.running = true;
            }
        }
    }

    Process {
        id: suspendProc

        command: ["systemctl", "suspend"]

        onExited: (code, status) => {
            if (code !== 0)
                console.warn("idle-qs: systemctl suspend failed, exit code " + code);
        }

        stderr: StdioCollector {
            onStreamFinished: {
                const t = this.text.trim();
                if (t !== "")
                    console.warn("idle-qs: systemctl suspend: " + t);
            }
        }
    }

    function statusText() {
        return "lock=" + root.lockMinutes + "min, sleep=" + root.sleepMinutes + "min, ignoreInhibitors=" + root.ignoreInhibitors + ", idle=" + idleMonitor.isIdle + ", suspendTimer=" + (suspendTimer.running ? "armed(" + root.suspendDelayMinutes + "min)" : "off");
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
