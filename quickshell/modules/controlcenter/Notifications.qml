import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Wayland
import qs.modules
import qs.modules.themeing

Scope {
    id: root

    property bool notifOpen: false

    ListModel {
        id: history
    }

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: (n) => {
            n.tracked = true;
            history.insert(0, {
                "summary": n.summary,
                "body": n.body,
                "appName": n.appName,
                "urgency": n.urgency,
                "time": Qt.formatDateTime(new Date(), "HH:mm")
            });
        }
    }

    IpcHandler {
        function toggle() {
            States.notifOpen = !States.notifOpen;
        }

        function show() {
            States.notifOpen = true;
        }

        function hide() {
            States.notifOpen = false;
        }

        target: "notifications-qs"
    }

    PanelWindow {
        color: "transparent"
        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            right: true
        }

        margins {
            top: States.barHeight + States.frameThickness + 5
            right: States.notifCardSideMargin
        }

        ColumnLayout {
            id: column

            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                delegate: Rectangle {
                    id: card

                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: States.frameRounding
                    color: Theme.rectcolor

                    Timer {
                        id: timer

                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        interval: States.notifTimeout
                        onTriggered: card.modelData.dismiss()
                    }

                    border {
                        width: 2
                        color: modelData.urgency === NotificationUrgency.Critical ? Theme.alertcolor : Theme.bordercolor
                    }

                    RowLayout {
                        id: layout

                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: modelData.summary
                                color: Theme.text1
                                elide: Text.ElideRight

                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontlg
                                    bold: true
                                }

                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: modelData.body
                                color: Theme.text1
                                wrapMode: Text.WordWrap

                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontmd
                                }

                            }

                        }

                    }

                    MouseArea {
                        id: dimClk

                        anchors.fill: parent
                        onClicked: {
                            card.modelData.dismiss();
                            timer.stop();
                        }
                    }

                }

            }

        }

    }
    //notification center

    PanelWindow {
        visible: States.notifOpen
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            right: true
            left: true
            bottom: true
        }

        margins {
            top: States.barHeight + States.frameThickness + 5
            right: States.notifCardSideMargin
        }

        MouseArea {
            anchors.fill: parent
            onClicked: States.notifOpen = !States.notifOpen
        }

        Rectangle {
            implicitWidth: 380
            implicitHeight: centerCol.implicitHeight + 24
            anchors.top: parent.top
            anchors.right: parent.right
            radius: 20
            color: Theme.bgcolor
            border {
                width: 2
                color: Theme.bordercolor
            }

            ColumnLayout {
                id: centerCol

                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: "Notifications"
                        color: Theme.text1

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxxl
                            bold: true
                        }

                    }

                    Text {
                        text: "Clear All"
                        color: clearHover.containsMouse && history.count > 0 ? Theme.textactive : (history.count > 0 ? Theme.text1 : Theme.textmuted)

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontlg
                        }

                        MouseArea {
                            id: clearHover

                            anchors.fill: parent
                            anchors.margins: -4
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: history.clear()
                        }

                    }

                }

                ColumnLayout {
                    id: cardCol

                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 2

                    Repeater {
                        model: history

                        delegate: ColumnLayout {
                            required property var modelData

                            Layout.fillWidth: true
                            spacing: 2

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.summary
                                    color: Theme.text1
                                    elide: Text.ElideRight

                                    font {
                                        family: Theme.fontfamily
                                        pixelSize: Theme.fontxl
                                        bold: true
                                    }

                                }

                                Text {
                                    text: modelData.time
                                    color: Theme.textmuted

                                    font {
                                        family: Theme.fontfamily
                                        pixelSize: Theme.fontmd
                                    }

                                }

                            }

                            Text {
                                Layout.fillWidth: true
                                visible: modelData.body !== ""
                                text: modelData.body
                                color: Theme.text1
                                wrapMode: Text.WordWrap

                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontmd
                                }

                            }

                            Text {
                                visible: modelData.appName !== ""
                                text: modelData.appName
                                color: Theme.textmuted

                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontsm
                                }

                            }

                        }

                    }

                }

            }

        }

    }

}
