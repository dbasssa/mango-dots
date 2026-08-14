pragma Singleton
import QtQuick

QtObject {
    id: root

    property var wallpapers: []
    property string currentWallpaper: "/home/tanish/walls/wp9516237-1211171744.png"
    property int currentIndex: 0 
    property bool pickerOpen: false

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
        root.pickerOpen = false
    }

    function closePicker() {
        root.pickerOpen = false
    }
}