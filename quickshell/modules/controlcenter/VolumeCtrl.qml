import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.modules
import qs.modules.themeing
import qs.services

Item {
    id: root

    Layout.fillWidth: true
    //the dropdown is an overlay, so the height of the widget never changes
    implicitHeight: flow.implicitHeight

    //dropdown state
    property bool outputMenuOpen: false
    //slider drag state, keeps the handle from lagging behind the pointer
    property bool dragging: false
    property int dragVol: 0
    readonly property int displayVol: root.dragging ? root.dragVol : Pipewire.vol
    //output dropdown metrics
    readonly property int entryHeight: 28
    readonly property int entrySpacing: 2
    readonly property int menuPadding: 8
    readonly property int menuGap: 4
    readonly property int menuHeight: Pipewire.sinks.length * (root.entryHeight + root.entrySpacing) + root.menuPadding
    //room between the output button and the bottom of the widget
    readonly property int spaceBelowButton: Math.max(0, root.height - outputBtn.height - root.menuGap)
    //extra height the control center needs so the dropdown is not cut off
    readonly property int extraHeight: root.outputMenuOpen ? Math.max(0, root.menuHeight - root.spaceBelowButton) : 0

    onExtraHeightChanged: States.ctrlExtraHeight = root.extraHeight
    Component.onCompleted: States.ctrlExtraHeight = root.extraHeight

    //close the dropdown when the audio page is hidden
    Connections {
        target: root.parent

        function onVisibleChanged() {
            if (!root.parent.visible)
                root.closeOutputMenu();
        }
    }

    //the control center is sized from the page contents, so it has to be
    //told to resize once the dropdown opens or closes.
    function toggleOutputMenu() {
        root.outputMenuOpen = !root.outputMenuOpen;
        if (States.reheight)
            States.reheight();
    }

    function closeOutputMenu() {
        if (!root.outputMenuOpen)
            return;
        root.outputMenuOpen = false;
        if (States.reheight)
            States.reheight();
    }

    ColumnLayout {
        id: flow

        anchors.fill: parent
        spacing: 8

        //================ output switcher ================

        Rectangle {
            id: outputBtn

            Layout.fillWidth: true
            implicitHeight: 34
            radius: States.tagRounding
            color: outputMouse.containsMouse || root.outputMenuOpen ? Theme.recthovercolor : Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                Text {
                    Layout.preferredWidth: 20
                    text: "󰕾"
                    color: Theme.text1
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontlg
                }

                Text {
                    text: "Output"
                    color: Theme.textmuted
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontbase
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    Layout.maximumWidth: 190
                    text: Pipewire.sinkName !== "" ? Pipewire.sinkName : "No output"
                    color: Theme.text1
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignRight
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontbase
                }

                Text {
                    text: root.outputMenuOpen ? "󰅃" : "󰅀"
                    color: Theme.textmuted
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontbase
                }
            }

            MouseArea {
                id: outputMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggleOutputMenu()
            }
        }

        //================ volume ================

        RowLayout {
            id: volumeRow

            Layout.fillWidth: true
            Layout.preferredHeight: 30
            spacing: 8

            //mute button
            Rectangle {
                id: muteBtn

                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                radius: States.sliderRounding
                color: muteMouse.containsMouse ? Theme.recthovercolor : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: Pipewire.muted ? "󰖁" : "󰕾"
                    color: Pipewire.muted ? Theme.alertcolor : Theme.text1
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontxl
                }

                MouseArea {
                    id: muteMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Pipewire.toggleMute()
                }
            }

            //slider
            Item {
                id: slider

                Layout.fillWidth: true
                Layout.preferredHeight: 30

                readonly property real handleR: 8
                readonly property real trackX: handleR
                readonly property real trackW: Math.max(1, width - handleR * 2)
                //0 - 1 position of the current volume
                readonly property real ratio: Math.max(0, Math.min(1, (root.displayVol - Pipewire.minVolume) / (Pipewire.maxVolume - Pipewire.minVolume)))
                //0 - 1 position of the 100% marker
                readonly property real unityRatio: Math.max(0, Math.min(1, (Pipewire.unityVolume - Pipewire.minVolume) / (Pipewire.maxVolume - Pipewire.minVolume)))
                readonly property real handleX: trackX + trackW * ratio
                readonly property real unityX: trackX + trackW * unityRatio

                //move the volume to wherever the pointer is
                function setFromX(x) {
                    let r = (x - trackX) / trackW;
                    r = Math.max(0, Math.min(1, r));
                    root.dragVol = Math.round(Pipewire.minVolume + r * (Pipewire.maxVolume - Pipewire.minVolume));
                    Pipewire.setVolume(root.dragVol);
                }

                //track
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    x: slider.trackX
                    width: slider.trackW
                    height: 5
                    radius: 3
                    color: Theme.rectcolor
                }

                //filled part up to 100%
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    x: slider.trackX
                    width: Math.max(0, Math.min(slider.handleX, slider.unityX) - slider.trackX)
                    height: 5
                    radius: 3
                    color: Pipewire.muted ? Theme.textmuted : Theme.textactive
                }

                //over 100% part
                Rectangle {
                    visible: slider.handleX > slider.unityX
                    anchors.verticalCenter: parent.verticalCenter
                    x: slider.unityX
                    width: slider.handleX - slider.unityX
                    height: 5
                    radius: 3
                    color: Theme.alertcolor
                }

                //100% marker
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    x: slider.unityX - 1
                    width: 2
                    height: 14
                    radius: 1
                    color: Theme.textmuted
                }

                //handle
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    x: slider.handleX - width / 2
                    width: 16
                    height: 16
                    radius: 8
                    color: sliderMouse.pressed ? Theme.textactive : Theme.text1

                    border {
                        width: 2
                        color: Theme.bgcolor
                    }
                }

                MouseArea {
                    id: sliderMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onPressed: {
                        root.dragging = true;
                        slider.setFromX(mouseX);
                    }
                    onPositionChanged: {
                        if (pressed)
                            slider.setFromX(mouseX);
                    }
                    onReleased: root.dragging = false
                    onCanceled: root.dragging = false
                    onWheel: {
                        if (wheel.angleDelta.y !== 0)
                            Pipewire.nudgeVolume(wheel.angleDelta.y > 0 ? 5 : -5);
                    }
                }
            }

            //percentage
            Text {
                Layout.preferredWidth: 40
                Layout.alignment: Qt.AlignHCenter
                text: root.displayVol + "%"
                color: Pipewire.muted ? Theme.textmuted : Theme.text1
                horizontalAlignment: Text.AlignRight
                font.family: Theme.fontfamily
                font.pixelSize: Theme.fontbase
            }
        }

        //================ microphone ================

        Rectangle {
            id: micBtn

            Layout.fillWidth: true
            implicitHeight: 34
            radius: States.tagRounding
            color: micMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                Text {
                    Layout.preferredWidth: 20
                    text: Pipewire.micMuted ? "󰍭" : "󰍬"
                    color: Pipewire.micMuted ? Theme.alertcolor : Theme.text1
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontlg
                }

                Text {
                    text: "Microphone"
                    color: Theme.textmuted
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontbase
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    Layout.maximumWidth: 190
                    text: Pipewire.micName !== "" ? Pipewire.micName : "No microphone"
                    color: Pipewire.micMuted ? Theme.textmuted : Theme.text1
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignRight
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontbase
                }
            }

            MouseArea {
                id: micMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Pipewire.toggleMicMute()
            }
        }

    }

    //================ output dropdown ================
    //drawn on top of the controls below it instead of pushing them down, so
    //the height of the widget itself never changes.

    Rectangle {
        id: outputMenu

        visible: root.outputMenuOpen
        z: 100
        x: 0
        y: outputBtn.height + root.menuGap
        width: root.width
        //the panel is at least as tall as the space it covers, so nothing
        //peeks out from behind it
        height: Math.max(root.menuHeight, root.spaceBelowButton + root.extraHeight)
        radius: States.tagRounding
        color: Theme.rectcolor

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        Column {
            id: outputList

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: root.menuPadding / 2
            spacing: root.entrySpacing

            Repeater {
                model: Pipewire.sinks

                delegate: Rectangle {
                    id: outputEntry

                    required property var modelData

                    width: outputList.width
                    height: root.entryHeight
                    radius: States.sliderRounding
                    color: entryMouse.containsMouse ? Theme.recthovercolor : "transparent"

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.right: checkIcon.visible ? checkIcon.left : parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: Pipewire.nodeLabel(outputEntry.modelData)
                        color: Theme.text1
                        elide: Text.ElideRight
                        font.family: Theme.fontfamily
                        font.pixelSize: Theme.fontbase
                    }

                    Text {
                        id: checkIcon

                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        visible: Pipewire.isCurrentSink(outputEntry.modelData)
                        text: "󰄬"
                        color: Theme.textactive
                        font.family: Theme.fontfamily
                        font.pixelSize: Theme.fontbase
                    }

                    MouseArea {
                        id: entryMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Pipewire.setDefaultSink(outputEntry.modelData);
                            root.closeOutputMenu();
                        }
                    }
                }
            }
        }
    }

}
