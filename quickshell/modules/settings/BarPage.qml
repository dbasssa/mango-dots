import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules
import qs.modules.themeing

Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: Theme.rectcolor

    RowLayout {
        spacing: 10

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            implicitHeight: 160
            implicitWidth: 150
            radius: 10
            color: Theme.rectcolor

            border {
                width: 3
                color: Theme.bordercolor
            }

            Text {
                text: "Full Bar"
                anchors.centerIn: parent
                color: Theme.text1

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontxxl
                }

            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    States.fullBar = true;
                    States.islandBar = false;
                    States.notchBar = false;
                }
            }

        }

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            implicitHeight: 160
            implicitWidth: 150
            radius: 10
            color: Theme.rectcolor

            border {
                width: 3
                color: Theme.bordercolor
            }

            Text {
                text: "Notch"
                anchors.centerIn: parent
                color: Theme.text1

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontxxl
                }

            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    States.fullBar = false;
                    States.islandBar = false;
                    States.notchBar = true;
                }
            }

        }

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            implicitHeight: 160
            implicitWidth: 150
            radius: 10
            color: Theme.rectcolor

            border {
                width: 3
                color: Theme.bordercolor
            }

            Text {
                text: "Island"
                anchors.centerIn: parent
                color: Theme.text1

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontxxl
                }

            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    States.islandBar = true;
                    States.fullBar = true;
                    States.notchBar = false;
                }
            }

        }

        Item {
            Layout.fillWidth: true
        }

    }

}
