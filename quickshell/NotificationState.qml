pragma Singleton
import QtQuick
import Quickshell.Wayland._ToplevelManagement

QtObject {
    id: root

    property var persistent: []

    function add(notification) {
        root.persistent = root.persistent.concat([notification])
    }

    function remove(notification) {
        root.persistent = root.persistent.filter(n => n !== notification)
    }

    function clearAll() {
        for (const n of root.persistent)
            n.dismiss()
        root.persistent = []
    }

    // Focuses the window belonging to the app that sent a notification.
    // Matches the notification's desktop entry / app name against the
    // compositor's foreign-toplevel app ids (case-insensitive).
    function focusApp(notification) {
        const targets = [notification.desktopEntry, notification.appName]
            .map(s => (s || "").toLowerCase())
            .filter(s => s !== "")
        if (targets.length === 0)
            return false

        for (const toplevel of ToplevelManager.toplevels.values) {
            const appId = (toplevel.appId || "").toLowerCase()
            if (appId === "")
                continue
            for (const t of targets) {
                if (appId.indexOf(t) !== -1 || t.indexOf(appId) !== -1) {
                    toplevel.activate()
                    return true
                }
            }
        }
        return false
    }
}
