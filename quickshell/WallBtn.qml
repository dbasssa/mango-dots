import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    anchors.horizontalCenter: parent.horizontalCenter
    Layout.preferredHeight: 40
    Layout.preferredWidth: 350

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: wallBtn.containsMouse ? Theme.recthovercolor : Theme.rectcolor

        border {
            color: Theme.bordercolor
            width: 1
        }

        Text {
            anchors.centerIn: parent
            text: "Wallpaper"
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontmd
            }

        }

    }

    MouseArea {
        id: wallBtn

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            States.ctrlOpen = false;
            States.wallPickerOpen = true;
        }
    }

}
