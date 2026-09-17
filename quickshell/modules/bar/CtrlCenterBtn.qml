import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules
import qs.modules.themeing

Rectangle {
    visible: States.notchBar ? false : true
    Layout.alignment: Qt.AlignHCenter
    implicitHeight: Math.round(States.barHeight * 0.75)
    implicitWidth: btnRow.implicitWidth + 10
    color: Theme.rectcolor
    radius: States.itemRounding
    clip: true

    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    RowLayout {
        id: btnRow
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.fill: parent
        spacing: 2

        VolumeBar {
        }
        Battery {}

        NwRect {}

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "|"
            color: Theme.text1
            font {
                pixelSize: Theme.fontxl * States.fontScale
                family: Theme.fontfamily
            }
        }

        Text {
            text: ""
            color: Theme.text1
            font {
                pixelSize: Theme.fontxl * States.fontScale
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
