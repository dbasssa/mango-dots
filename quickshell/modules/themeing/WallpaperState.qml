import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel
pragma Singleton

Singleton {
    id: root

    readonly property string wallsPath: Quickshell.shellDir + "/walls" + ThemeState.themes[ThemeState.themeIndex].folder
    property string currentWallpaper: ""
    property Process pywalProc
    property Process saveWalProc
    property FolderListModel randomModel: FolderListModel {
        folder: "file://" + root.wallsPath
        showDirs: false
        nameFilters: ["*.jpg","*.png","*.jpeg","*.webp","*.bmp"]
    }
    property bool randomPending: false

    Connections {
        target: root.randomModel
        function onStatusChanged() {root.tryPickRandom()}
        function onCountChanged() {root.tryPickRandom()}
    }


    saveWalProc: Process {
        command: []
        running: false
    }
    function saveWal(path) {
        saveWalProc.command = ["sh","-c","echo " + path + " > " + Quickshell.shellDir + "/state/wallpaper"]
        saveWalProc.running = true
    }

    pywalProc: Process {
        command: []
        running: false
    }

    function colorWal(path) {
        pywalProc.command = ["wal", "-i", path, "-n", "-q"];
        pywalProc.running = true;
    }

    function fileBasename(path) {
        return path.split("/").reverse()[0] ?? path;
    }

    function select(pathOrName) {
        if (!pathOrName)
            return ;

        const value = pathOrName.toString();
        root.currentWallpaper = value.startsWith("file:") ? value : root.wallsPath + "/" + value;
        root.colorWal(value.replace("file://", ""));
        root.saveWal(value.replace("file://", ""))
    }

    function tryPickRandom() {
        if (!root.randomPending || root.randomModel.status !== FolderListModel.Ready || root.randomModel.count <= 0) return;
        root.randomPending = false;
        const i = Math.floor(Math.random() * root.randomModel.count);
        root.select(root.randomModel.get(i,"fileUrl"));
    }

    function randomWal() {
        root.randomPending = true;
    }

    function isCurrent(name) {
        return root.fileBasename(root.currentWallpaper) === name;
    }

}
