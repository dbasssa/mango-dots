import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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
        top: States.frameVis ? 53 : 50
    }

    property bool animOpen: false
    visible: animOpen
    property string searchText: ""
    property int selectedIndex: 0
    property var filteredApps: []
    readonly property int itemHeight: 36
    readonly property int maxVisible: 8
    readonly property int listMaxHeight: maxVisible * (itemHeight + 4) + 12

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

    function scrollToSelected() {
        var targetY = root.selectedIndex * (root.itemHeight + 4)
        var currentY = appFlickable.contentY
        var viewH = appFlickable.height
        if (targetY < currentY)
            appFlickable.contentY = targetY
        else if (targetY + root.itemHeight > currentY + viewH)
            appFlickable.contentY = targetY + root.itemHeight - viewH
    }

    function launch(entry) {
        States.appOpen = false
        searchText = ""
        selectedIndex = 0
        if (entry.execString) {
            var cmd = entry.execString.replace(/%[FfUu]/g, "").trim()
            if (cmd.length > 0) {
                launchProc.command = ["sh", "-c", cmd + " &"]
                launchProc.running = true
            }
        }
    }

    property var launchProc: Process {}

    IpcHandler {
        target: "AppLauncher"
        function toggle() {
            States.appOpen = !States.appOpen
            States.ctrlOpen = false
        }
    }

    Connections {
        function onAppOpenChanged() {
            if (States.appOpen) {
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
        target: States
    }

    onSearchTextChanged: doFilter()
    onSelectedIndexChanged: scrollToSelected()

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
                            if (root.filteredApps.length > 0) {
                                root.selectedIndex = Math.min(root.selectedIndex + 1, root.filteredApps.length - 1)
                            }
                        }
                        Keys.onUpPressed: {
                            root.selectedIndex = Math.max(root.selectedIndex - 1, 0)
                        }
                        Keys.onReturnPressed: {
                            if (root.filteredApps.length > 0 && root.selectedIndex < root.filteredApps.length)
                                root.launch(root.filteredApps[root.selectedIndex])
                        }
                        Keys.onEscapePressed: {
                            States.appOpen = false
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

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(root.filteredApps.length, root.maxVisible) * (root.itemHeight + 4) + 12
                visible: root.filteredApps.length > 0

                Flickable {
                    id: appFlickable
                    anchors.fill: parent
                    anchors.margins: 2
                    contentHeight: appColumn.implicitHeight
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    flickableDirection: Flickable.VerticalFlick

                    Column {
                        id: appColumn
                        width: parent.width
                        spacing: 4

                        Repeater {
                            id: appRepeater
                            model: root.filteredApps.length

                            Rectangle {
                                width: appColumn.width
                                height: root.itemHeight
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
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: root.filteredApps.length > root.maxVisible ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                        contentItem: Rectangle {
                            implicitWidth: 4
                            radius: 2
                            color: parent.pressed ? Theme.textactive : Theme.textmuted
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        background: Rectangle {
                            color: Theme.rectcolor
                            radius: 2
                        }
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
