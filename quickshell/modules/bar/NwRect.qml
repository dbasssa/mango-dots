import Quickshell
import Quickshell.Networking
import QtQuick

import qs.modules
import qs.modules.themeing
//fuck this you are taking way too long to work 
Item {
    id: root
    implicitHeight: netRect.implicitHeight
    implicitWidth: netRect.implicitWidth + 5
    property bool wifiEnabled: Networking.wifiEnabled
    readonly property list<NetworkDevice> devices: Networking.devices.values
    property WifiDevice wifiDev: devices.find(dev => dev.type === DeviceType.Wifi) ?? null
    property WiredDevice wiredDev: devices.find(dev => dev.type === DeviceType.Wired) ?? null
    property list<WifiNetwork> wifiNetworks: wifiDev?.networks.values ?? []
    readonly property string activeWiredName: wiredDev?.networks.values.find(n => n.connected)?.name ?? ""
    readonly property string activeNetName: wifiDev?.networks.values.find(n => n.connected)?.name ?? ""

    //wifi function (fuck the name of ur wifi)
    function wifiConnection() {
        if (wifiDev != null) {
            if (wifiDev.state === ConnectionState.Connected) {
                return "󰖩" 
            }
            if (wifiDev.state === ConnectionState.Connecting) {
                return "󱛆"

            }
            if (wifiDev.state === ConnectionState.Disconnected) {
                return "󱛅"
            }
            if (wifiDev.state === ConnectionState.Disconnecting) {
                return "󱛆"
            }
        } else {
            return;
        }
    }

    //fuck this you dont need this on ethernet you pussy look at ur motherboard... THERES LIGHTS THERE FOR A REASON
    function wiredConnection() {
        if (wiredDev != null) {
            if (wiredDev.state === ConnectionState.Connected) {
                return "suck my balls: "
            }
            if (wiredDev.state === ConnectionState.Disconnected || wiredDev.state === ConnectionState.Unknown) {
                return "they killed kenny"
            }
        }

    }

    Rectangle {
        id: netRect
        anchors.centerIn: parent
        implicitHeight: 25
        implicitWidth: wiredTxt.visible ? wiredTxt.implicitWidth + 5 : wifiTxt.implicitWidth + 5
        color: "transparent"


        //wifi network shit
        Text {
            id:wifiTxt
            visible: wifiDev != null
            anchors.centerIn: parent
            text: root.wifiConnection()
            color: Theme.text1
        }
        //wired network shitu
        Text {
            anchors.centerIn: parent
            visible: wiredDev != null
            id: wiredTxt
            text: " " +  root.wiredConnection() + root.activeWiredName//pussy i hated writing this
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }
    }
}