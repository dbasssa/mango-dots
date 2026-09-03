import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules
import qs.modules.themeing

Rectangle {
    visible: States.notchBar ? false : true
    Layout.alignment: Qt.AlignHCenter
    implicitHeight: 25
    implicitWidth: btnRow.implicitWidth + 10
    color: Theme.rectcolor
    radius: 12
    clip: true

    RowLayout {
        id: btnRow
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.fill: parent
        spacing: 2

        VolumeBar {
        }
        Battery {}

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "|"
            color: Theme.text1
            font {
                pixelSize: Theme.fontxl
                family: Theme.fontfamily
            }
        }

        Text {
            text: ""
            color: Theme.text1
            font {
                pixelSize: Theme.fontxl
                family: Theme.fontfamily
            }
        }



    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: States.ctrlOpen = !States.ctrlOpen
    }

}
