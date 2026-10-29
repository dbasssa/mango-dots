pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

QtObject {
    id: root

    property ListModel history: ListModel {}

    property NotificationServer server: NotificationServer {
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: (n) => {
            n.tracked = true;
            root.history.insert(0, {
                "summary": n.summary,
                "body": n.body,
                "appName": n.appName,
                "urgency": n.urgency,
                "time": Qt.formatDateTime(new Date(), "HH:mm")
            });
        }
    }

    function clearHistory() {
        root.history.clear();
    }
}