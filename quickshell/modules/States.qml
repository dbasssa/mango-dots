import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    // Theme picker overlay open/closed
    // Wallpaper picker overlay open/closed
    //Appearance Settings (changeable in Settings app)
    //save everything and make it happen again (i forgot the fuckin word)
    //rounding asaver
    //Bar style saver

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

    function saveWidth() {
        widthSaver.command = [];
        widthSaver.running = true;
    }

    function saveGap() {
        gapSaver.command = [];
        gapSaver.running = true;
    }

    function saveRound() {
        roundingSaver.command = [];
        roundingSaver.running = true;
    }

    //bar height saver
    property Process heightSaver: Process {
        command: ["sh", "-c", "echo " + root.barHeight + " > " + Quickshell.shellDir + "/state/height"]
        running: false
    }

    property Process heightReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/height"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.barHeight = parseInt(this.text)
        }

    }
    //end of height saver

    //bar width
    property Process widthSaver: Process {
        command: ["sh", "-c", "echo " + root.barWidth + " > " + Quickshell.shellDir + "/state/width"]
        running: false
    }

    property Process widthReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/width"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.barWidth = parseInt(this.text)
        }

    }
    //end of width saver

    //gap saver (yes 90% of this file is a copy pasta)
    property Process gapSaver: Process {

        command: ["sh", "-c", "echo " + root.notchMargin + " > " + Quickshell.shellDir + "/state/gap"]
        running: false
    }

    property Process gapReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/gap"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.notchMargin = parseInt(this.text)
        }

    }
    //end of gap save

    property Process roundingSaver: Process {
        command: ["sh", "-c", "echo " + root.barRounding + " > " + Quickshell.shellDir + "/state/rounding"]
        running: false
    }

    property Process roundingReader: Process {
        command: ["sh", "-c", "cat " + Quickshell.shellDir + "/state/rounding"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.barRounding = parseInt(this.text)
        }

    }
    //end of rounding saver

    //bar style saver 

    property Process notchStyle: Process {
        command: ["sh","-c","echo notch > " + Quickshell.shellDir + "/state/barstyle"]
        running: false
    }

}
