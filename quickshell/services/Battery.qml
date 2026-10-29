pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.UPower
import Quickshell.Io

Singleton {
    id: root
    property bool exists: UPower.displayDevice.isLaptopBattery
    property int percentage: Math.round(UPower.displayDevice.percentage * 100)
    property bool isCharging: UPower.displayDevice.state === UPowerDeviceState.Charging
    property var chargerIcon: ["", ""]
    Process {
        id: lowBatProc
        running: root.exists ? (root.isCharging ? false : root.percentage < 20) : false
        command: ["sh", "-c", "notify-send -u critical 'Battery Low' 'Please connect a charger'"]
    }
    Process {
        id: chargingBat
        running: root.exists ? (root.isCharging ? true : false) : false
        command: ["sh", "-c", "notify-send 'Battery is charging' 'Thank you for not killing me'"]
    }
    function get_Battery_Icon() {
        if (root.exists) {
            if (root.isCharging) {
                return "";
            } else if (root.percentage >= 80) {
                return "";
            } else if (root.percentage >= 60) {
                return "";
            } else if (root.percentage >= 40) {
                return "";
            } else if (root.percentage >= 20) {
                return "";
            } else if (root.percentage >= 0) {
                return "";
            } else {
                return "weird battery error";
            }
        } else {
            return "no bat";
        }
    }
    function charge_Icon() {
        if (root.isCharging) {
            return "󱐋";
        } else {
            return "";
        }
    }
}
