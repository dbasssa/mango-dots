pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

import qs.services

QtObject {
    id: root

    //do not disturb — suppresses popup and lockscreen cards for everything
    //except critical urgency (those always display). the history page keeps
    //recording all notifications either way. persisted in state.json.
    property bool dnd: StateStore.get("dnd", false)
    property bool hydrated: false
    Component.onCompleted: {
        root.hydrated = true;
        root.syncTracked();
    }
    onDndChanged: if (root.hydrated) StateStore.set("dnd", root.dnd)

    //history entries are { live, view, snap, time }:
    //  live — the live Notification while it is open, null once closed
    //  view — what the card renders: the live object while open, otherwise
    //         the plain snapshot taken at arrival
    //  snap — plain data copy of the notification
    //  time — "HH:mm" arrival time
    //quickshell 0.3 closes a notification as soon as it is untracked (which
    //is what the popup timeout does), so the snapshot is what keeps history
    //entries around after their card is gone.
    property var history: []

    //cap so a long session can't grow the list forever
    readonly property int maxHistory: 100

    //currently-live notifications, kept in sync for the lock screen counter
    //(the server's model is an UntypedObjectModel; .values is the plain list)
    property var tracked: []
    readonly property int trackedCount: root.tracked.length

    function syncTracked() {
        root.tracked = root.server.trackedNotifications.values ?? [];
    }

    property NotificationServer server: NotificationServer {
        actionsSupported: true
        bodySupported: true
        imageSupported: true
        //keep notifications alive across config reloads
        keepOnReload: true

        onNotification: (n) => {
            n.closed.connect(() => root.archive(n));
            //always track so the server owns the notification's lifetime
            //(untracked ones never expire or emit closed). DND is a display
            //concern only — popup/lockscreen cards filter on shouldDisplay(),
            //history still records everything.
            n.tracked = true;
            const next = [{
                live: n,
                view: n,
                snap: root.snapshot(n),
                time: Qt.formatDateTime(new Date(), "HH:mm")
            }].concat(root.history);
            if (next.length > root.maxHistory) {
                const dropped = next.splice(root.maxHistory);
                for (let i = 0; i < dropped.length; i++)
                    if (dropped[i].live)
                        dropped[i].live.dismiss();
            }
            root.history = next;
        }
    }

    property Connections trackedConnections: Connections {
        target: root.server

        function onTrackedNotificationsChanged() {
            root.syncTracked();
        }
    }

    //plain data copy of a notification, renderable after it has closed
    function snapshot(n) {
        return {
            summary: n.summary,
            body: n.body,
            appName: n.appName,
            appIcon: n.appIcon,
            image: n.image,
            urgency: n.urgency,
            actions: [],
            tracked: false
        };
    }

    //the notification closed (expired, dismissed, or untracked) — keep its
    //history entry, but swap the live object for the snapshot so nothing
    //dangles and the entry stays in the control center
    function archive(n) {
        root.history = root.history.map(entry => entry.live === n ? {
            live: null,
            view: entry.snap,
            snap: entry.snap,
            time: entry.time
        } : entry);
    }

    //whether a notification should show popup/lockscreen cards right now:
    //DND suppresses everything except critical urgency
    function shouldDisplay(n) {
        return !root.dnd || n.urgency === NotificationUrgency.Critical;
    }

    //remove one history entry, closing the notification if it is still open
    function dismissEntry(entry) {
        root.history = root.history.filter(e => e !== entry);
        if (entry.live)
            entry.live.dismiss();
    }

    function clearHistory() {
        const all = root.history;
        root.history = [];
        for (let i = 0; i < all.length; i++)
            if (all[i].live)
                all[i].live.dismiss();
    }
}
