import QtQuick
import QtQuick.Layouts
import qs.modules
import qs.modules.themeing

ColumnLayout {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 8

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
            color: clearHover.containsMouse && NotificationState.history.count > 0 ? Theme.textactive : (NotificationState.history.count > 0 ? Theme.text1 : Theme.textmuted)

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
                onClicked: NotificationState.clearHistory()
            }

        }

    }

    ListView {
        id: list

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 320
        spacing: 8
        clip: true
        model: NotificationState.history

        delegate: Rectangle {
            required property var modelData

            width: list.width
            implicitHeight: col.implicitHeight + 10
            radius: States.tagRounding
            color: Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            ColumnLayout {
                id: col

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 6
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
                            pixelSize: Theme.fontlg
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