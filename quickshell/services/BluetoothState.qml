pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root
    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property var devices: Bluetooth.devices?.values ?? []
    readonly property var connectedDev: root.devices.filter(device => device.connected)
    readonly property string status: {
        if (!root.adapter) {
            return "Unavailable";
        }
        if (root.adapter.state === BluetoothAdapterState.Enabled) {
            return "On";
        }
        if (root.adapter.state === BluetoothAdapterState.Disabled) {
            return "Off";
        }
        if (root.adapter.state === BluetoothAdapterState.Enabling) {
            return "Enabling";
        }
        if (root.adapter.state === BluetoothAdapterState.Disabling) {
            return "Disabling";
        }
        if (root.adapter.state === BluetoothAdapterState.Blocked) {
            return "Blocked";
        }
    }
}
