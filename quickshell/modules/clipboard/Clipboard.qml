import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules
import qs.modules.themeing
import qs.services

//clipboard history overlay — reads cliphist's database through ClipboardState
PanelWindow {
    id: root

    visible: States.clipboardOpen
    color: "#99000000"
    exclusionMode: ExclusionMode.Ignore
    focusable: true
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }

    IpcHandler {
        function toggle() {
            States.clipboardOpen = !States.clipboardOpen;
        }

        target: "clipboard-qs"
    }

    readonly property var filtered: {
        const q = search.text.trim().toLowerCase();
        if (q === "")
            return ClipboardState.entries;
        return ClipboardState.entries.filter(entry => entry.preview.toLowerCase().indexOf(q) >= 0);
    }

    onVisibleChanged: {
        if (!root.visible)
            return;
        ClipboardState.refresh();
        search.text = "";
        search.forceActiveFocus();
        list.currentIndex = 0;
    }

    Shortcut {
        sequence: "Escape"
        onActivated: States.clipboardOpen = false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: States.clipboardOpen = false
    }

    Rectangle {
        id: card

        anchors.centerIn: parent
        width: Math.min(760, root.width - 80)
        height: Math.min(560, root.height - 80)
        color: Theme.bgcolor
        radius: States.panelRounding

        border {
            width: States.borderOn ? States.borderThick : 0
            color: Theme.bordercolor
        }

        //this rectangle is inside the backdrop MouseArea above: swallow
        //clicks that land on the card itself
        MouseArea {
            anchors.fill: parent
        }

        function copyCurrent() {
            const entry = list.model[list.currentIndex];
            if (!entry)
                return;
            ClipboardState.copy(entry.id);
            States.clipboardOpen = false;
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            RowLayout {
                Layout.fillWidth: true

                Text {
                    Layout.fillWidth: true
                    text: "Clipboard"
                    color: Theme.text1

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                        bold: true
                    }
                }

                Text {
                    text: ClipboardState.entries.length + (ClipboardState.entries.length === 1 ? " item" : " items")
                    color: Theme.textmuted

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                    }
                }
            }

            TextField {
                id: search

                Layout.fillWidth: true
                implicitHeight: 44
                placeholderText: "Search clipboard history…"
                placeholderTextColor: Theme.textmuted
                color: Theme.text1
                selectByMouse: true

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontlg
                }

                background: Rectangle {
                    color: Theme.rectcolor
                    radius: States.tagRounding

                    border {
                        width: States.borderOn ? 1 : 0
                        color: Theme.bordercolor
                    }
                }

                Keys.onDownPressed: {
                    if (list.count === 0)
                        return;
                    list.currentIndex = Math.min(list.currentIndex + 1, list.count - 1);
                    list.positionViewAtIndex(list.currentIndex, ListView.Contain);
                }
                Keys.onUpPressed: {
                    if (list.count === 0)
                        return;
                    list.currentIndex = Math.max(list.currentIndex - 1, 0);
                    list.positionViewAtIndex(list.currentIndex, ListView.Contain);
                }
                onAccepted: card.copyCurrent()
            }

            ListView {
                id: list

                Layout.fillWidth: true
                Layout.fillHeight: true
                model: root.filtered
                spacing: 6
                clip: true
                currentIndex: 0

                onCountChanged: currentIndex = 0

                delegate: Rectangle {
                    required property var modelData
                    required property int index

                    width: list.width
                    implicitHeight: previewText.implicitHeight + 20
                    radius: States.tagRounding
                    color: list.currentIndex === index || entryHover.containsMouse ? Theme.recthovercolor : Theme.rectcolor

                    border {
                        width: States.borderOn ? 1 : 0
                        color: list.currentIndex === index ? Theme.textactive : Theme.bordercolor
                    }

                    Text {
                        id: previewText

                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        text: modelData.preview
                        color: Theme.text1
                        elide: Text.ElideRight

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontmd
                        }
                    }

                    MouseArea {
                        id: entryHover

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            ClipboardState.copy(modelData.id);
                            States.clipboardOpen = false;
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                visible: list.count === 0
                text: search.text.trim() !== "" ? "No matches" : "Clipboard history is empty"
                color: Theme.textmuted
                horizontalAlignment: Text.AlignHCenter

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontlg
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    Layout.fillWidth: true
                    text: "↑/↓ select · Enter copy · Esc close"
                    color: Theme.textmuted

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontsm
                    }
                }

                Text {
                    text: "Clear All"
                    color: clearHover.containsMouse && ClipboardState.entries.length > 0 ? Theme.alertcolor : Theme.textmuted

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                    }

                    MouseArea {
                        id: clearHover

                        anchors.fill: parent
                        anchors.margins: -4
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ClipboardState.clear()
                    }
                }
            }
        }
    }
}
