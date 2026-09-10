import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

import qs.modules.themeing

QtObject {


    id: root

    // App launcher open/closed
    property bool appOpen: false
    // Control center open/closed
    property bool ctrlOpen: false
    //Settings App opener
    property bool settingsOpen: true
    //Notification center opener
    property bool notifOpen: false
    //lock screen toggle
    property bool lockScreen: false
    //System Monitor toggle
    property bool statsOpen: false
    property bool themeOpen: false
    property bool funTime: false
    property bool wallOpen: false
    //Bar dimensions when in pill/island mode (bound)
    property int barHeight: 40
    property int barWidth: 200
    //Bars Available Types (Bound)
    property bool fullBar: true
    property bool islandBar: false
    property bool notchBar: false
    //toggles the screen frame along the edges of the monitor (Bound)
    property bool frameVis: true
    property int frameThickness: 5
    property int frameRounding: 5
    //outer gap inside bar (Bound)
    property int barMargin: 12
    //Gap from top of screen to top of notch (Bound)
    property int notchMargin: 5
    //Bar Rounding (Bound)
    property int barRounding: 20
    //notification Card timer & Margin
    property int notifCardSideMargin: 10
    property int notifTimeout: 5000

    property bool wsVisible: true
    property bool appsVisible: true
    property bool clockVisible: true
    property bool buttonsVisible: true






    //bar height saver
    property Process heightSaver
    property Process heightReader
    //bar width
    property Process widthSaver
    property Process widthReader
    //gap saver (yes 90% of this file is a copy pasta)
    property Process gapSaver
    property Process gapReader
    property Process roundingSaver
    property Process roundingReader
    property Process notchStyle
    property Process fullBarStyle
    property Process islandStyle
    property Process styleReader
        property Process readWal

    readWal: Process {
        command: ["sh","-c","cat " + Quickshell.shellDir + "/state/wallpaper"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: WallpaperState.currentWallpaper = this.text.trim()

        }

    }

    function fullBarSelect() {
        root.fullBar = true
        root.islandBar = false
        root.notchBar = false
    }
    function islandBarSelect() {
        root.fullBar = true
        root.islandBar = true
        root.notchBar = false
    }
        function notchSelect() {
        root.fullBar = false
        root.islandBar = false
        root.notchBar = true
    }

    heightSaver: Process {
        command: ["sh", "-c", "echo " + root.barHeight + " > " + Quickshell.shellDir + "/state/height"]
        running: false
    }

    heightReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/height"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.barHeight = parseInt(this.text)
        }

    }
    //end of height saver

    widthSaver: Process {
        command: ["sh", "-c", "echo " + root.barWidth + " > " + Quickshell.shellDir + "/state/width"]
        running: false
    }

    widthReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/width"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.barWidth = parseInt(this.text)
        }

    }
    //end of width saver

    gapSaver: Process {
        command: ["sh", "-c", "echo " + root.notchMargin + " > " + Quickshell.shellDir + "/state/gap"]
        running: false
    }

    gapReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/gap"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.notchMargin = parseInt(this.text)
        }

    }
    //end of gap save

    roundingSaver: Process {
        command: ["sh", "-c", "echo " + root.barRounding + " > " + Quickshell.shellDir + "/state/rounding"]
        running: false
    }

    roundingReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/rounding"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.barRounding = parseInt(this.text)
        }

    }
    //end of rounding saver

    //bar style you cunt
    notchStyle: Process {
        command: ["sh", "-c", "echo notch > " + Quickshell.shellDir + "/state/barstyle"]
        running: false
    }

    fullBarStyle: Process {
        command: ["sh", "-c", "echo full > " + Quickshell.shellDir + "/state/barstyle"]
        running: false
    }

    islandStyle: Process {
        command: ["sh", "-c", "echo island > " + Quickshell.shellDir + "/state/barstyle"]
        running: false
    }

    styleReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/barstyle"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text === "notch") {
                    root.fullBar = false;
                    root.islandBar = false;
                    root.notchBar = true;
                } else if (this.text === "island") {
                    root.fullBar = true;
                    root.islandBar = true;
                    root.notchBar = false;
                } else if (this.text === "full") {
                    root.fullBar = true;
                    root.islandBar = false;
                    root.notchBar = false;
                }
            }
        }

    }

    //end of bar style 


    //frame settings 

}
