import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import qs.modules
import qs.modules.themeing

Scope {
    id: root

    PanelWindow {
        color: "transparent"
        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay

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
                model: NotificationState.server.trackedNotifications

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

}