pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string wallsPath: Quickshell.shellDir + "/walls" + ThemeState.themes[ThemeState.themeIndex].folder

    property string currentWallpaper: root.wallsPath + "*.jpg"

    function fileBasename(path) {
        return path.split("/").reverse()[0] ?? path
    }

    function select(pathOrName) {
        if (!pathOrName) return
        const value = pathOrName.toString()
        root.currentWallpaper = value.startsWith("file:") ? value : root.wallsPath + "/" + value
    }

    function isCurrent(name) {
        return root.fileBasename(root.currentWallpaper) === name
    }
}