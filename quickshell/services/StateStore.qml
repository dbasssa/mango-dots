pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    //single json file for every persisted setting, replacing the old
    //one-text-file-per-value scheme under state/.
    //
    // - FileView writes are atomic, so a crash mid-write can't corrupt it
    // - quickshell only reloads the config for *.qml changes, so saving
    //   state never restarts the shell
    // - a missing or corrupt file just falls back to defaults instead of dying
    property var data: ({})

    //value of key, or fallback when it is missing/null
    function get(key, fallback) {
        const value = root.data[key];
        return (value === undefined || value === null) ? fallback : value;
    }

    //store key and rewrite state.json (skips no-op writes)
    function set(key, value) {
        if (root.data[key] === value)
            return;
        const next = Object.assign({}, root.data);
        next[key] = value;
        root.data = next;
        file.setText(JSON.stringify(next, null, 2));
    }

    //drop key from state.json
    function remove(key) {
        if (!(key in root.data))
            return;
        const next = Object.assign({}, root.data);
        delete next[key];
        root.data = next;
        file.setText(JSON.stringify(next, null, 2));
    }

    //the initial read is blocking (FileView.text() loads synchronously while
    //blockLoading is set), so every StateStore.get() binding evaluates
    //against persisted values instead of defaults. watchChanges stays off —
    //onLoaded fires from inside text() itself, so re-parsing there would loop.
    function load() {
        try {
            root.data = JSON.parse(file.text());
        } catch (e) {
            root.data = {};
        }
    }

    FileView {
        id: file

        path: Quickshell.shellDir + "/state/state.json"
        blockLoading: true
        atomicWrites: true
        watchChanges: false
        printErrors: false

        Component.onCompleted: root.load()
    }
}
