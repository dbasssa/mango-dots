import Qt.labs.folderlistmodel
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules

PanelWindow {
    id: root

    function select(index) {
        if (index < 0 || index >= wallList.count)
            return ;

        WallpaperState.select(wallModel.get(index, "fileUrl"));
        States.wallOpen = false;
    }

    visible: States.wallOpen
    color: "#99000000"
    exclusionMode: ExclusionMode.Ignore
    focusable: true
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    onVisibleChanged: {
        if (!root.visible)
            return ;

        for (let i = 0; i < wallModel.count; i++) {
            if (WallpaperState.isCurrent(wallModel.get(i, "fileName"))) {
                wallList.currentIndex = i;
                break;
            }
        }
    }

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }

    IpcHandler {
        function toggle() {
            States.wallOpen = !States.wallOpen;
        }

        target: "walls-qs"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: States.wallOpen = false
    }

    FolderListModel {
        id: wallModel

        folder: "file://" + WallpaperState.wallsPath
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp"]
        showDirs: false
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: root.width - 80
        spacing: 14

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Wallpapers"
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontxl
                bold: true
            }

        }

        ListView {
            id: wallList

            Layout.fillWidth: true
            Layout.preferredHeight: 300
            orientation: ListView.Horizontal
            model: wallModel
            currentIndex: 0
            spacing: 14
            clip: true
            focus: root.visible
            keyNavigationEnabled: false
            onCurrentIndexChanged: {
                if (root.visible) {
                    positionViewAtIndex(currentIndex, ListView.Center);
                }
            }
            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape)
                    States.wallOpen = false;
                else if (event.key === Qt.Key_Left || event.key === Qt.Key_H)
                    decrementCurrentIndex();
                else if (event.key === Qt.Key_Right || event.key === Qt.Key_L)
                    incrementCurrentIndex();
                else if (event.key === Qt.Key_Return)
                    root.select(currentIndex);
            }

            delegate: Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                required property url fileUrl
                required property int index

                width: wallList.currentIndex === index ? 516 : 430
                height: wallList.currentIndex === index ? 288 : 240
                radius: 10
                color: Theme.rectcolor

                border {
                    width: 2
                    color: wallList.currentIndex === index ? Theme.textactive : Theme.bordercolor
                }

                Image {
                    anchors.fill: parent
                    anchors.margins: 4
                    source: fileUrl
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    clip: true
                    sourceSize: Qt.size(800, 450)
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.select(index)
                }

            }

        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "←/→ or h/l to move · Enter to select · Esc to close"
            color: Theme.textmuted

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontsm
            }

        }

    }

}
