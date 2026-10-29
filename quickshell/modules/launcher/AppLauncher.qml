import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.modules
import qs.modules.themeing

PanelWindow {
    id: root

    readonly property string mode: appSearch.text.startsWith(">>") ? "shell" : appSearch.text.startsWith(":") ? "command" : "apps"
    readonly property string query: appSearch.text.slice(mode === "shell" ? 2 : mode === "command" ? 1 : 0)
    property var pending: null

    // ':' palette entries. run() fires AFTER the launcher finishes closing, because
    // Settings and WallSelector also request exclusive keyboard focus.
    property var commands: [
        {
            name: "Settings",
            keys: "Open the Settings Panel",
            run: () => root.afterClose(() => States.settingsOpen = !States.settingsOpen)
        },
        {
            name: "Theme",
            keys: "change the color scheme",
            run: () => root.afterClose(() => States.themeOpen = !States.themeOpen)
        },
        {
            name: "Wallpaper",
            keys: "change the wallpaper/bg",
            run: () => root.afterClose(() => States.wallOpen = !States.wallOpen)
        },
        {
            name: "Control Center",
            keys: "open the control center",
            run: () => root.afterClose(() => States.ctrlOpen = !States.ctrlOpen)
        },
        {
            name: "Lock Screen",
            keys: "Lock your Session",
            run: () => root.afterClose(() => States.lockScreen = !States.lockScreen)
        }
    ]

    property bool closing: false
    visible: States.appOpen || root.closing
    focusable: true
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    color: "transparent"

    IpcHandler {
        target: "app-launcher"
        function toggle() {
            root.toggleLauncher();
        }
        function invoke() {
            root.toggleLauncher();
        }
    }
    NumberAnimation {
        id: openAnim
        target: contentRect
        property: "height"
        duration: 400
        easing.type: Easing.OutCubic
    }
    NumberAnimation {
        id: closeAnim
        target: contentRect
        property: "height"
        duration: 400
        easing.type: Easing.OutCubic
        onRunningChanged: {
            if (!running && root.closing) {
                root.closing = false;
                States.appOpen = false;
                // hand off to whatever the ':' command asked for, now that we no longer hold the keyboard
                if (root.pending) {
                    const fn = root.pending;
                    root.pending = null;
                    fn();
                }
            }
        }
    }

    // '>>' shell. fire and forget: no output pane, stderr goes to the quickshell log.
    Process {
        id: shellProc

        command: ["sh", "-c", ""]
        running: false
        stderr: StdioCollector {
            onStreamFinished: {
                const t = this.text.trim();
                if (t !== "")
                    console.warn("shell: " + t);
            }
        }
    }

    function filteredApps() {
        const q = root.query.toLowerCase();
        return DesktopEntries.applications.values.filter(x => {
            return (q === "" || x.name.toLowerCase().includes(q) || x.keywords.some(k => k.toLowerCase().includes(q))) && !x.noDisplay && !x.runInTerminal;
        });
    }

    function filteredCommands() {
        const q = root.query.trim().toLowerCase();
        if (q === "")
            return root.commands;
        return root.commands.filter(c => c.name.toLowerCase().includes(q) || c.keys.toLowerCase().includes(q));
    }

    function afterClose(fn) {
        // already on the way out, so the keyboard is about to be released anyway
        if (root.closing || !States.appOpen) {
            fn();
            return;
        }
        root.pending = fn;
        root.closeLauncher();
    }

    function runCommand(cmd) {
        if (cmd && cmd.run)
            cmd.run();
    }

    function runShell() {
        const cmd = root.query.trim();
        if (cmd === "")
            return;
        shellProc.command = ["sh", "-c", cmd];
        shellProc.running = true;
        root.closeLauncher();
    }

    function runCurrent() {
        if (mode === "shell") {
            root.runShell();
            return;
        }
        if (appList.currentItem)
            appList.currentItem.runCurrent();
    }

    function moveSelection(dir) {
        if (mode === "shell")
            return;
        if (dir < 0)
            appList.decrementCurrentIndex();
        else
            appList.incrementCurrentIndex();
    }

    function closeLauncher() {
        if (root.closing || !States.appOpen)
            return;
        root.closing = true;
        openAnim.stop();
        closeAnim.from = contentRect.height;
        closeAnim.to = 0;
        closeAnim.restart();
    }

    function toggleLauncher() {
        if (States.appOpen) {
            if (root.closing) {
                root.closing = false;
                closeAnim.stop();
                openAnim.from = 0;
                openAnim.to = 500;
                openAnim.restart();
            } else {
                root.closeLauncher();
            }
        } else {
            States.appOpen = true;
        }
    }

    onModeChanged: appList.positionViewAtBeginning()

    onVisibleChanged: {
        if (root.visible)
            root.pending = null;
        appSearch.text = "";
        appList.currentIndex = 0;
        if (root.visible) {
            closeAnim.stop();
            contentRect.height = 0;
            openAnim.from = 0;
            openAnim.to = 500;
            openAnim.restart();
        }
    }

    Rectangle {
        id: contentRect
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 650
        height: 500
        color: Theme.bgcolor
        radius: States.panelRounding
        border {
            width: States.borderOn ? 2 : 0
            color: Theme.bordercolor
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            TextField {
                id: appSearch
                placeholderText: " : for shell, >> for bash"
                focus: root.visible
                color: Theme.textactive
                placeholderTextColor: Theme.textmuted
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                leftPadding: 12
                rightPadding: 12
                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontxxl
                }
                background: Rectangle {
                    color: Theme.rectcolor
                    radius: States.tagRounding
                    border {
                        width: States.borderOn ? 2 : 0
                        color: Theme.bordercolor
                    }
                }
                onTextChanged: appList.currentIndex = 0

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        root.closeLauncher();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Up) {
                        root.moveSelection(-1);
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Down) {
                        root.moveSelection(1);
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        root.runCurrent();
                        event.accepted = true;
                    }
                }
            }

            Rectangle {
                id: listRect
                clip: true
                visible: root.mode !== "shell"
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                ListView {
                    id: appList
                    anchors.fill: parent
                    spacing: 4
                    currentIndex: 0
                    highlightRangeMode: ListView.ApplyRange
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: height - 50

                    model: ScriptModel {
                        values: root.mode === "command" ? root.filteredCommands() : root.filteredApps()
                    }

                    delegate: Item {
                        id: delegate
                        width: appList.width
                        height: 48

                        function runCurrent() {
                            if (root.mode === "command")
                                root.runCommand(modelData);
                            else {
                                modelData.execute();
                                root.closeLauncher();
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: delegate.ListView.isCurrentItem ? Theme.text1 : Theme.rectcolor
                            radius: States.tagRounding

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8

                                Rectangle {
                                    Layout.preferredWidth: 32
                                    Layout.preferredHeight: 32
                                    visible: root.mode !== "command"
                                    color: "transparent"
                                    Image {
                                        anchors.centerIn: parent
                                        source: root.mode === "command" || !modelData || !modelData.icon ? "" : "image://icon/" + modelData.icon
                                        sourceSize: Qt.size(24, 24)
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }

                                Text {
                                    text: modelData ? modelData.name : ""
                                    color: delegate.ListView.isCurrentItem ? Theme.rectcolor : Theme.text1
                                    font {
                                        family: Theme.fontfamily
                                        pixelSize: Theme.fontxl
                                        bold: true
                                    }
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    visible: root.mode === "command"
                                    text: root.mode === "command" && modelData ? modelData.keys : ""
                                    color: delegate.ListView.isCurrentItem ? Theme.rectcolor : Theme.textmuted
                                    font {
                                        family: Theme.fontfamily
                                        pixelSize: Theme.fontsm
                                    }
                                    elide: Text.ElideRight
                                    Layout.maximumWidth: 240
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (delegate.ListView.isCurrentItem)
                                    delegate.runCurrent();
                                else
                                    appList.currentIndex = index;
                            }
                        }
                    }
                }
            }

            Text {
                id: shellHint
                visible: root.mode === "shell"
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: root.query.trim() === "" ? "type a command, ↵ to run" : "↵ to run  ·  esc to close"
                color: Theme.textmuted
                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontbase
                }
                elide: Text.ElideMiddle
            }
        }
    }
}
