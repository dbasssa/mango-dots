import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import qs.modules
import qs.modules.themeing

Item {
    implicitHeight: 20
    implicitWidth: batRect.implicitWidth
    id: root
    visible: root.exists

    property bool exists: UPower.displayDevice.isLaptopBattery

    property int percentage: Math.round(UPower.displayDevice.percentage * 100)

    property bool isCharging: UPower.displayDevice.state === UPowerDeviceState.Charging
    //why the fuck are you running with no battery??? are you hihg???? nevermind NOW you work after i made the same damn edit
    Process {
        id: lowBatProc
        running: root.exists ? (root.percentage < 15 ? true : false) : false
        command: ["sh","-c","notify-send -u critical 'Battery Low' 'Please connect a charger'"]
    }
    Process {
        id: chargingBat
        running: root.exists ? (root.isCharging ? true: false) : false
        command: ["sh","-c","notify-send 'Battery is charging' 'Thank you for not killing me'"]
    }

    Rectangle {
        id: batRect
        implicitHeight: parent.implicitHeight
        implicitWidth: batText.implicitWidth
        color: Theme.rectcolor

        Text {
            id:batText
            anchors.centerIn: parent
            text: root.isCharging ? root.percentage + "% 󰂄" : root.percentage + "% 󰁹"
            color: root.isCharging ? Theme.miconcolor : (root.percentage <= 15 ? Theme.alertcolor : Theme.text1)
            font {
                pixelSize: Theme.fontlg
                family: Theme.fontfamily
            }
        }
    }
}