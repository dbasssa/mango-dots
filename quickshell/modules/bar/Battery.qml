import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs.modules
import qs.modules.themeing

Item {
    implicitHeight: 20
    implicitWidth: 20
    id: root

    property bool exists: UPower.displayDevice.isLaptopBattery

    property int percentage: Math.round(UPower.displayDevice.percentage * 100)

    Rectangle {
        anchors.fill:parent
        color: Theme.rectcolor

        Text {
            anchors.centerIn: parent
            text: root.exists ? "󰁹" : "󰐧"
            color: Theme.text1
            font {
                pixelSize: Theme.fontxl
            }
        }
    }
}