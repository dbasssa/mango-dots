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

    //bluetooth on/off
    readonly property bool btEnabled: root.adapter != null && root.adapter.enabled

    function toggleBluetooth() {
        if (root.adapter == null) {
            return;
        }
        root.adapter.enabled = !root.adapter.enabled;
    }

    //device level bluetooth actions
    function pairDevice(device) {
        if (device != null) {
            device.pair();
        }
    }

    function connectDevice(device) {
        if (device != null) {
            device.connect();
        }
    }

    function disconnectDevice(device) {
        if (device != null) {
            device.disconnect();
        }
    }

    function forgetDevice(device) {
        if (device != null) {
            device.forget();
        }
    }

    //bluetooth discovery
    readonly property bool btDiscovering: root.adapter != null && root.adapter.discovering

    function toggleDiscovering() {
        if (root.adapter == null) {
            return;
        }
        root.adapter.discovering = !root.adapter.discovering;
    }

    //battery icon for a bluetooth device, using the same icon set as the upower battery service
    function btBatteryIcon(device) {
        if (!device || !device.batteryAvailable)
            return "";
        var pct = Math.round(device.battery * 100);
        if (pct >= 80)
            return "";
        if (pct >= 60)
            return "";
        if (pct >= 40)
            return "";
        if (pct >= 20)
            return "";
        return "";
    }
    function btDeviceIcon(device) {
      if (!device) return "yo shit gay";
      switch (device.icon) {
        case "audio-headset": return "";
        case "audio-headphones": return "";
        case "audio-card": return "󰓃";
        case "input-keyboard": return "󰌌";
        case "input-mouse": return "󰍽";
        case "input-gaming": return "";
        case "phone": return "";
        case "computer": return "";
        case "input-tablet": return "";
        default: return "";
      }
    }
}
