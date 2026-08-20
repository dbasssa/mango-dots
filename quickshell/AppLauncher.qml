import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    implicitHeight: launcherBody.implicitHeight + 24
    implicitWidth: 650

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    anchors {
        top: true
    }

    margins {
        top: 50
    }

    property bool animOpen: false
    visible: animOpen
    property string searchText: ""
    property int selectedIndex: 0
    property var filteredApps: []

    function doFilter() {
        var apps = []
        var all = DesktopEntries.applications.values
        if (!all) {
            filteredApps = []
            return
        }
        for (var i = 0; i < all.length; i++) {
            var entry = all[i]
            if (entry.noDisplay) continue
            if (searchText.length === 0) {
                apps.push(entry)
                if (apps.length >= 5) break
            } else {
                var q = searchText.toLowerCase()
                var n = entry.name ? entry.name.toLowerCase() : ""
                var g = entry.genericName ? entry.genericName.toLowerCase() : ""
                var id = entry.id ? entry.id.toLowerCase() : ""
                if (n.indexOf(q) >= 0 || g.indexOf(q) >= 0 || id.indexOf(q) >= 0)
                    apps.push(entry)
            }
        }
        filteredApps = apps
        if (selectedIndex >= apps.length)
            selectedIndex = Math.max(0, apps.length - 1)
    }

    function launch(entry) {
        AppLauncherState.open = false
        searchText = ""
        selectedIndex = 0
        if (entry.command.length > 0) {
            launchProc.command = entry.command
            launchProc.running = true
        }
    }

    property var launchProc: Process {}

    IpcHandler {
        target: "AppLauncher"
        function toggle() {
            AppLauncherState.open = !AppLauncherState.open
        }
    }

    Connections {
        function onOpenChanged() {
            if (AppLauncherState.open) {
                root.animOpen = true
                searchText = ""
                selectedIndex = 0
                doFilter()
                Qt.callLater(openAnim.start)
                Qt.callLater(searchInput.forceActiveFocus)
            } else {
                searchInput.text = ""
                closeAnim.start()
            }
        }
        target: AppLauncherState
    }

    onSearchTextChanged: doFilter()

    Rectangle {
        id: launcherBody
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: 650
        implicitHeight: contentCol.implicitHeight + 24
        color: Theme.bgcolor
        border { width: 2; color: Theme.bordercolor }
        radius: 12
        opacity: 0
        scale: 0.97

        transform: Translate { id: launcherT; y: -20 }

        ColumnLayout {
            id: contentCol
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                height: 36
                radius: 6
                color: Theme.rectcolor
                border { width: 1; color: Theme.bordercolor }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Text {
                        text: "󰍜"
                        color: Theme.textmuted
                        font { family: Theme.fontfamily; pixelSize: Theme.fontmd }
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        color: Theme.text1
                        font { family: Theme.fontfamily; pixelSize: Theme.fontmd }
                        clip: true
                        focus: true
                        cursorVisible: true

                        onTextChanged: {
                            root.searchText = text
                            root.selectedIndex = 0
                        }

                        Keys.onDownPressed: {
                            if (root.filteredApps.length > 0)
                                root.selectedIndex = Math.min(root.selectedIndex + 1, root.filteredApps.length - 1)
                        }
                        Keys.onUpPressed: {
                            root.selectedIndex = Math.max(root.selectedIndex - 1, 0)
                        }
                        Keys.onReturnPressed: {
                            if (root.filteredApps.length > 0 && root.selectedIndex < root.filteredApps.length)
                                root.launch(root.filteredApps[root.selectedIndex])
                        }
                        Keys.onEscapePressed: {
                            AppLauncherState.open = false
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.bordercolor
                visible: root.filteredApps.length > 0
            }

            Repeater {
                id: appRepeater
                model: root.filteredApps.length

                Rectangle {
                    Layout.fillWidth: true
                    height: 36
                    radius: 6
                    color: root.selectedIndex === index ? Theme.recthovercolor : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 10

                        IconImage {
                            implicitSize: 22
                            source: "image://icon/" + (root.filteredApps[index] ? root.filteredApps[index].icon : "")
                        }

                        Text {
                            Layout.fillWidth: true
                            text: root.filteredApps[index] ? root.filteredApps[index].name : ""
                            color: Theme.text1
                            font { family: Theme.fontfamily; pixelSize: Theme.fontmd }
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.launch(root.filteredApps[index])
                        onEntered: root.selectedIndex = index
                    }
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                visible: root.filteredApps.length === 0 && root.searchText.length > 0
                text: "no results"
                color: Theme.textmuted
                font { family: Theme.fontfamily; pixelSize: Theme.fontsm }
            }
        }
    }

    ParallelAnimation {
        id: openAnim
        NumberAnimation { target: launcherBody; property: "opacity"; to: 1; duration: 200; easing.type: Easing.OutCubic }
        NumberAnimation { target: launcherT; property: "y"; to: 0; duration: 240; easing.type: Easing.OutCubic }
        NumberAnimation { target: launcherBody; property: "scale"; to: 1; duration: 200; easing.type: Easing.OutCubic }
    }

    SequentialAnimation {
        id: closeAnim
        ParallelAnimation {
            NumberAnimation { target: launcherBody; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InCubic }
            NumberAnimation { target: launcherT; property: "y"; to: -20; duration: 170; easing.type: Easing.InCubic }
            NumberAnimation { target: launcherBody; property: "scale"; to: 0.97; duration: 150; easing.type: Easing.InCubic }
        }
        ScriptAction { script: root.animOpen = false }
    }
}
