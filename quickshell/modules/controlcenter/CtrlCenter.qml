import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules
import qs.modules.themeing

PanelWindow {
    id: root

    property bool closing: false
    visible: States.ctrlOpen || root.closing
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    //animated height of the control center panel
    property real ctrlH: 0

    //chrome height: margins 10+10 + tab row 20 + column spacing 10
    function desiredHeight() {
        let pageH = 0;
        if (root.currentPage === 0) pageH = audioPage.implicitHeight;
        else if (root.currentPage === 1) pageH = connectionsPage.implicitHeight;
        else if (root.currentPage === 2) pageH = appearancePage.implicitHeight;
        else if (root.currentPage === 3) pageH = systemPage.implicitHeight;
        else if (root.currentPage === 4) pageH = powerPage.implicitHeight;
        else if (root.currentPage === 5) pageH = notificationsPage.implicitHeight;
        return Math.max(1, pageH + 50);
    }

    NumberAnimation {
        id: openAnim

        target: root
        property: "ctrlH"
        duration: 400
        easing.type: Easing.OutCubic
    }

    NumberAnimation {
        id: closeAnim

        target: root
        property: "ctrlH"
        duration: 400
        easing.type: Easing.OutCubic
        onRunningChanged: {
            if (!running && root.closing) {
                root.closing = false;
                States.ctrlOpen = false;
            }
        }
    }

    Component.onCompleted: {
        States.ctrlCloser = () => root.closePanel();
        States.reheight = () => root.reheight();
    }

    function closePanel() {
        if (root.closing || !States.ctrlOpen)
            return;
        root.closing = true;
        openAnim.stop();
        closeAnim.to = 0;
        closeAnim.restart();
    }

    function togglePanel() {
        if (States.ctrlOpen) {
            if (root.closing) {
                root.closing = false;
                closeAnim.stop();
                openAnim.to = root.desiredHeight();
                openAnim.restart();
            } else {
                root.closePanel();
            }
        } else {
            States.ctrlOpen = true;
        }
    }

    function reheight() {
        if (!root.visible || root.closing)
            return;
        openAnim.stop();
        openAnim.to = root.desiredHeight();
        openAnim.restart();
    }

    onVisibleChanged: {
        if (root.visible) {
            closeAnim.stop();
            root.ctrlH = 0;
            openAnim.to = root.desiredHeight();
            openAnim.restart();
        }
    }

    onCurrentPageChanged: {
        if (root.visible && !root.closing) {
            openAnim.stop();
            openAnim.to = root.desiredHeight();
            openAnim.restart();
        }
    }

    anchors {
        top: true
        right: true
        left: true
        bottom: true
    }

    margins {
        top: States.barHeight + States.frameThickness + 5
        right: States.frameThickness + 5
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.togglePanel()
    }

    IpcHandler {
        function toggle() {
            root.togglePanel();
        }

        target: "ctrlcntr-qs"
    }

    property int currentPage: 0

    Rectangle {
        id: ctrlrect

        color: Theme.bgcolor
        implicitHeight: root.ctrlH
        implicitWidth: 460
        anchors.right: parent.right
        anchors.top: parent.top
        radius: States.panelRounding
        clip: true

        border {
            color: Theme.bordercolor
            width: States.borderOn ? 2 : 0
        }

        ColumnLayout {
            id: centerCol

            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            RowLayout {
                spacing: 2
                Layout.fillWidth: true
                Repeater {
                    model: ["Audio","Connections","Appearance","System","Power","Notifications"]

                    delegate: Rectangle {
                        implicitHeight: 20
                        implicitWidth: modelTxt.implicitWidth + 7
                        radius: States.sliderRounding
                        color: root.currentPage === model.index ? Theme.occupiedcolor : Theme.bgcolor

                        border {
                            width: States.borderOn ? 1 : 0
                            color: Theme.bordercolor
                        }

                        Text {
                            id: modelTxt

                            anchors.centerIn: parent
                            text: modelData
                            color: Theme.text1

                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontmd
                            }

                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.currentPage = model.index
                        }
                    }
                }
            }

            AudioPage {
                id: audioPage

                Layout.fillWidth: true
                visible: root.currentPage === 0
            }

            ConnectionsPage {
                id: connectionsPage

                Layout.fillWidth: true
                visible: root.currentPage === 1
            }

            AppearancePage {
                id: appearancePage

                Layout.fillWidth: true
                visible: root.currentPage === 2
            }

            SystemPage {
                id: systemPage

                Layout.fillWidth: true
                visible: root.currentPage === 3
            }

            PowerPage {
                id: powerPage

                Layout.fillWidth: true
                visible: root.currentPage === 4
            }

            NotificationsPage {
                id: notificationsPage

                Layout.fillWidth: true
                visible: root.currentPage === 5
            }

        }

    }

}