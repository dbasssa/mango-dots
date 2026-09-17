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
    property bool settingsOpen: false
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
    property real fontScale: Math.max(0.75, Math.min(2.0, root.barHeight / 30.0))
    //Bars Available Types (Bound)
    property bool fullBar: true
    property bool islandBar: false
    property bool notchBar: false
    //toggles the screen frame along the edges of the monitor (Bound)
    property bool frameVis: false
    property int frameThickness: 5
    property int frameRounding: 0
    //outer gap inside bar (Bound)
    property int barMargin: 12
    //Gap from top of screen to top of notch (Bound)
    property int notchMargin: 5
    //Bar Rounding (Bound)
    property int barRounding: 0
    //General Rounding Scale
    property int panelRounding: 20
    property int itemRounding: 20
    property int tagRounding: 10
    property int sliderRounding: 5
    //notification Card timer & Margin
    property int notifCardSideMargin: 10
    property int notifTimeout: 5000

    property bool wsVisible: true
    property bool appsVisible: true
    property bool clockVisible: true
    property bool buttonsVisible: true
    property bool trayVisible: true
    property bool borderOn: false
    property int borderThick: 2






    //bar height
    property Process heightReader
    //bar width
    property Process widthReader
    //gap reader
    property Process gapReader
    //rounding reader
    property Process roundingReader
    //frame settings readers
    property Process frameReader
    property Process frameThickReader
    property Process frameRoundReader
    property Process styleReader
    property Process readWal
    //universal state saver
    property Process stateSaver

    readWal: Process {
        command: ["sh","-c","cat " + Quickshell.shellDir + "/state/wallpaper"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: WallpaperState.currentWallpaper = this.text.trim()

        }

    }

    //universal save: echo <value> > state/<file>
    function saveState(file, value) {
        if (!root.stateSaver) return
        if (root.stateSaver.running)
            root.stateSaver.running = false
        root.stateSaver.command = ["sh", "-c", "echo " + value + " > " + Quickshell.shellDir + "/state/" + file]
        root.stateSaver.running = true
    }

    function fullBarSelect() {
        root.fullBar = true
        root.islandBar = false
        root.notchBar = false
        root.saveState("barstyle", "full")
    }
    function islandBarSelect() {
        root.fullBar = true
        root.islandBar = true
        root.notchBar = false
        root.saveState("barstyle", "island")
    }
        function notchSelect() {
        root.fullBar = false
        root.islandBar = false
        root.notchBar = true
        root.saveState("barstyle", "notch")
    }

    heightReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/height"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var v = parseInt(this.text)
                if (!isNaN(v)) root.barHeight = v
            }
        }

    }
    //end of height saver

    widthReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/width"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var v = parseInt(this.text)
                if (!isNaN(v)) root.barWidth = v
            }
        }

    }
    //end of width saver

    gapReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/gap"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var v = parseInt(this.text)
                if (!isNaN(v)) root.notchMargin = v
            }
        }

    }
    //end of gap save

    roundingReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/rounding"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var v = parseInt(this.text)
                if (!isNaN(v)) root.barRounding = v
            }
        }

    }
    //end of rounding saver

    //bar style you cunt
    styleReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/barstyle"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() === "notch") {
                    root.fullBar = false;
                    root.islandBar = false;
                    root.notchBar = true;
                } else if (this.text.trim() === "island") {
                    root.fullBar = true;
                    root.islandBar = true;
                    root.notchBar = false;
                } else if (this.text.trim() === "full") {
                    root.fullBar = true;
                    root.islandBar = false;
                    root.notchBar = false;
                }
            }
        }

    }

    //end of bar style 

    //universal state saver (runs echo <value> > state/<file> via saveState())
    stateSaver: Process {
        command: ["sh", "-c", "true"]
        running: false
    }

    //frame settings readers
    frameReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/framevis"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.frameVis = (this.text.trim() === "true")
        }
    }

    frameThickReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/framethickness"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var v = parseInt(this.text)
                if (!isNaN(v)) root.frameThickness = v
            }
        }
    }

    frameRoundReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/framerounding"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var v = parseInt(this.text)
                if (!isNaN(v)) root.frameRounding = v
            }
        }
    }

}
