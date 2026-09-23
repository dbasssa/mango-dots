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
        duration: 600
        easing.type: Easing.OutCubic
    }
    NumberAnimation {
        id: closeAnim
        target: contentRect
        property: "height"
        duration: 600
        easing.type: Easing.OutCubic
        onRunningChanged: {
            if (!running && root.closing) {
                root.closing = false;
                States.appOpen = false;
            }
        }
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

    onVisibleChanged: {
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
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 650
        height: 500
        color: Theme.bgcolor
        radius: States.panelRounding
        border { width: States.borderOn ? 2: 0; color: Theme.bordercolor }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            TextField {
                id: appSearch
                placeholderText: "Search..."
                focus: root.visible
                color: Theme.textactive
                placeholderTextColor: Theme.textmuted
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                leftPadding: 12; rightPadding: 12
                font { family: Theme.fontfamily; pixelSize: Theme.fontxxl; bold: true }
                background: Rectangle {
                    color: Theme.rectcolor
                    radius: States.tagRounding
                    border { width: States.borderOn ? 2 : 0; color: Theme.bordercolor }
                }
                onTextChanged: appList.currentIndex = 0
            }

            Rectangle {
                clip: true
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
                        values: DesktopEntries.applications.values.filter(x => {
                            var q = appSearch.text.toLowerCase()
                            return (q === "" || x.name.toLowerCase().includes(q)
                                || x.keywords.some(k => k.toLowerCase().includes(q)))
                                && !x.noDisplay && !x.runInTerminal
                        })
                    }

                    delegate: Item {
                        id: delegate
                        width: appList.width
                        height: 48

                        function launch() {
                            modelData.execute()
                            root.closeLauncher()
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
                                    color: "transparent"
                                    Image {
                                        anchors.centerIn: parent
                                        source: "image://icon/" + modelData.icon
                                        sourceSize: Qt.size(24, 24)
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }

                                Text {
                                    text: modelData.name
                                    color: delegate.ListView.isCurrentItem ? Theme.rectcolor : Theme.text1
                                    font { family: Theme.fontfamily; pixelSize: Theme.fontxl; bold: true }
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (delegate.ListView.isCurrentItem)
                                    delegate.launch()
                                else
                                    appList.currentIndex = index
                            }
                        }
                    }
                }
            }

            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape) root.closeLauncher()
                else if (event.key === Qt.Key_Up) appList.decrementCurrentIndex()
                else if (event.key === Qt.Key_Down) appList.incrementCurrentIndex()
                else if (event.key === Qt.Key_Return && appList.currentItem)
                    appList.currentItem.launch()
            }
        }
    }
}
