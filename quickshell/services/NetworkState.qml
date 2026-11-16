pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    //NOTE: this singleton must never be named "Network" — Quickshell.Networking
    //exports a C++ type with that exact name, and the type silently shadows the
    //singleton in any file importing both modules (all bindings turn undefined).
    //this applies to NetworkDevice, Networking, ConnectionState, etc. as well.

    //every network device quickshell knows about (wifi radios, ethernet ports...)
    readonly property list<NetworkDevice> devices: Networking.devices.values
    property WifiDevice wifiDev: root.devices.find(dev => dev.type === DeviceType.Wifi) ?? null
    property WiredDevice wiredDev: root.devices.find(dev => dev.type === DeviceType.Wired) ?? null

    //wifi
    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property list<WifiNetwork> wifiNetworks: root.wifiDev?.networks.values ?? []
    readonly property bool wifiConnected: root.wifiDev != null && root.wifiDev.state === ConnectionState.Connected
    readonly property string wifiName: root.wifiNetworks.find(n => n.connected)?.name ?? ""
    readonly property real signalStrength: root.wifiNetworks.find(n => n.connected)?.signalStrength ?? 0
    readonly property var wifiSecurity: root.wifiNetworks.find(n => n.connected)?.security
    readonly property string wifiStatus: root.wifiDev == null ? "Unavailable"
        : !root.wifiEnabled ? "Disabled"
        : root.wifiConnected ? "Connected"
        : root.wifiDev.state === ConnectionState.Connecting ? "Connecting"
        : "Disconnected"

    //state glyphs for the bar module
    readonly property string wifiIcon: root.wifiDev == null ? ""
        : root.wifiDev.state === ConnectionState.Connected ? " 󰖩"
        : root.wifiDev.state === ConnectionState.Connecting ? " 󱛆"
        : root.wifiDev.state === ConnectionState.Disconnected ? " 󱛅"
        : root.wifiDev.state === ConnectionState.Disconnecting ? " 󱛆"
        : ""

    function toggleWifi() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    //wired
    readonly property bool wiredConnected: root.wiredDev != null && root.wiredDev.state === ConnectionState.Connected
    readonly property string wiredName: root.wiredDev?.networks.values.find(n => n.connected)?.name ?? ""
    readonly property bool wiredHasLink: root.wiredDev?.hasLink ?? false
    readonly property int wiredLinkSpeed: root.wiredDev?.linkSpeed ?? 0
    readonly property string wiredStatus: root.wiredDev == null ? "Unavailable" : root.wiredConnected ? "Connected" : "Disconnected"

    readonly property string wiredIcon: root.wiredDev == null ? ""
        : root.wiredDev.state === ConnectionState.Connected ? " 󰈁"
        : root.wiredDev.state === ConnectionState.Disconnected || root.wiredDev.state === ConnectionState.Unknown ? " 󰈂"
        : "󰈂 wait..."

    //the active connection — ethernet wins whenever a cable is plugged in
    readonly property string activeLabel: root.wiredConnected ? "Ethernet" : "Wi-Fi"
    readonly property string activeIcon: root.wiredConnected ? "󰈁" : "󰖩"
    readonly property string activeStatus: root.wiredConnected ? root.wiredStatus : root.wifiStatus
    readonly property bool activeConnected: root.activeStatus === "Connected"
    readonly property string activeDetail: root.wiredConnected ? root.wiredName : root.wifiName
}
