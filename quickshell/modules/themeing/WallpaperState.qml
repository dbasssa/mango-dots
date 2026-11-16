pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel
import qs.services

Singleton {
    id: root

    readonly property string wallsPath: Quickshell.shellDir + "/walls" + ThemeState.themes[ThemeState.themeIndex].folder
    readonly property string wallsRoot: Quickshell.shellDir + "/walls"
    //persisted through StateStore (was state/wallpaper, saved with an
    //unquoted echo that broke on paths containing spaces)
    property string currentWallpaper: StateStore.get("wallpaper", "")
    property Process pywalProc
    //image count per theme folder, e.g. { dark: 12, kanagawa: 0 }
    property var wallpaperCounts: ({})
    property bool countsReady: false
    property FolderListModel randomModel: FolderListModel {
        folder: "file://" + root.wallsPath
        showDirs: false
        nameFilters: ["*.jpg", "*.png", "*.jpeg", "*.webp", "*.bmp"]
    }
    property bool randomPending: false

    Connections {
        target: root.randomModel
        function onStatusChanged() {
            root.tryPickRandom();
        }
        function onCountChanged() {
            root.tryPickRandom();
        }
    }

    pywalProc: Process {
        command: []
        running: false
    }

    function colorWal(path) {
        //quote the path (wallpapers can contain spaces) and only run the
        //mango hook when install.sh created it
        pywalProc.command = ["sh", "-c",
            "wal -i \"$1\" -n -q && { f=\"${XDG_CONFIG_HOME:-$HOME/.config}/mango/mango-wal.sh\"; "
            + "[ -f \"$f\" ] && bash \"$f\"; }",
            "sh", path];
        pywalProc.running = true;
    }

    function fileBasename(path) {
        return path.split("/").reverse()[0] ?? path;
    }

    function select(pathOrName) {
        if (!pathOrName)
            return;

        const value = pathOrName.toString();
        root.currentWallpaper = value.startsWith("file:") ? value : root.wallsPath + "/" + value;
        root.colorWal(value.replace("file://", ""));
        StateStore.set("wallpaper", value.replace("file://", ""));
    }

    function tryPickRandom() {
        if (!root.randomPending || root.randomModel.status !== FolderListModel.Ready || root.randomModel.count <= 0)
            return;
        root.randomPending = false;
        const i = Math.floor(Math.random() * root.randomModel.count);
        root.select(root.randomModel.get(i, "fileUrl"));
    }

    function randomWal() {
        root.randomPending = true;
    }

    function isCurrent(name) {
        return root.fileBasename(root.currentWallpaper) === name;
    }

    function folderKey(folder) {
        return (folder || "").replace(/^\/+|\/+$/g, "");
    }

    function countFor(theme) {
        if (!theme)
            return -1;
        return root.wallpaperCounts[root.folderKey(theme.folder)] ?? -1;
    }

    //block a theme only once the scan has finished, so a slow scan can't lock
    //the picker. a folder that is missing from the map counts as empty.
    function themeHasWallpapers(theme) {
        if (!theme || !root.countsReady)
            return true;
        return root.countFor(theme) > 0;
    }

    //next theme in `dir` direction that actually has wallpapers
    function nextSelectableTheme(from, dir) {
        const themes = ThemeState.themes;
        for (let step = 1; step <= themes.length; step++) {
            const i = ((from + dir * step) % themes.length + themes.length) % themes.length;
            if (root.themeHasWallpapers(themes[i]))
                return i;
        }
        return from;
    }

    //count images per theme folder so empty themes can be blocked in the
    //pickers instead of applying colors and leaving no wallpaper behind
    Process {
        id: scanProc

        command: ["sh", "-c",
            "for d in \"" + root.wallsRoot + "\"/*/; do "
            + "[ -d \"$d\" ] || continue; "
            + "n=$(find \"$d\" -maxdepth 1 -type f | grep -icE '\\.(jpe?g|png|webp|bmp)$'); "
            + "printf '%s %s\\n' \"$(basename \"$d\")\" \"$n\"; done"]
        running: true
        stdout: StdioCollector {}

        onExited: {
            const map = {};
            const lines = stdout.text.trim().split("\n");
            for (let i = 0; i < lines.length; i++) {
                const line = lines[i];
                if (line === "")
                    continue;
                const sp = line.lastIndexOf(" ");
                if (sp <= 0)
                    continue;
                const key = line.substring(0, sp);
                const n = parseInt(line.substring(sp + 1));
                map[key] = isNaN(n) ? 0 : n;
            }
            root.wallpaperCounts = map;
            root.countsReady = true;
        }
    }
}
