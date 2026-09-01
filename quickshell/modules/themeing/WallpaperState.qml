pragma Singleton
import QtQuick
import Quickshell.Io

import qs.modules

QtObject {
    id: root

    property var wallpapers: []
    property string currentWallpaper: "/home/tanish/walls/nord/11356515.jpg"
    property int currentIndex: 0
    property bool loaded: false

    property var wpReader: Process {
        command: ["cat", "/home/tanish/.config/quickshell/state/wallpaper"]
        stdout: StdioCollector {}
        running: true
        onExited: {
            var val = stdout.text.trim()
            if (val.length > 0) {
                root.currentWallpaper = val
                pywalProc.command = ["sh", "-c", "wal -i " + val + " && pywalfox update && kitty @ set-colors --configured ~/.cache/wal/colors-kitty.conf"]
                pywalProc.running = true
            }
            root.loaded = true
            doScan()
        }
    }

    property var wpWriter: Process {
        command: ["sh", "-c", "printf '%s' '" + root.currentWallpaper + "' > /home/tanish/.config/quickshell/state/wallpaper"]
    }

    property var pywalProc: Process {
        command: ["sh", "-c", "wal -i " + root.currentWallpaper + " && pywalfox update &"]
    }

    property bool pickRandom: false

    property var scanner: Process {
        stdout: StdioCollector {}
        onExited: {
            const files = stdout.text
                .split("\n")
                .map(f => f.trim())
                .filter(f => f.length > 0)
            root.wallpapers = files
            if (files.length > 0 && root.pickRandom) {
                root.pickRandom = false
                root.currentIndex = Math.floor(Math.random() * files.length)
                root.apply()
            } else {
                var idx = files.indexOf(root.currentWallpaper)
                root.currentIndex = idx >= 0 ? idx : 0
            }
        }
    }

    function doScan(random) {
        if (random) root.pickRandom = true
        scanner.command = ["find", ThemeState.wallPath, "-maxdepth", "1", "-type", "f", "-printf", "%p\n"]
        scanner.running = true
    }

    function loadWallpapers(list) {
        root.wallpapers = list
        var idx = list.indexOf(root.currentWallpaper)
        root.currentIndex = idx >= 0 ? idx : 0
    }

    function cycle(dir) {
        if (root.wallpapers.length === 0) return
        root.currentIndex = (root.currentIndex + dir + root.wallpapers.length) % root.wallpapers.length
    }

    function apply() {
        if (root.wallpapers.length === 0) return
        root.currentWallpaper = root.wallpapers[root.currentIndex]
        States.wallPickerOpen = false
        wpWriter.running = true
        pywalProc.command = ["sh", "-c", "wal -i " + root.currentWallpaper + " && pywalfox update && kitty @ set-colors --configured ~/.cache/wal/colors-kitty.conf"]
        pywalProc.running = true
    }

    function closePicker() {
        States.wallPickerOpen = false
    }
}
