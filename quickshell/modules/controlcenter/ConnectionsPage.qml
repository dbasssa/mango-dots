import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import qs.modules
import qs.modules.themeing
import qs.services

ColumnLayout {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 10

    Text {
        text: "Connections"
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontxxl
            bold: true
        }
    }

    readonly property list<NetworkDevice> devices: Networking.devices.values
    property WifiDevice wifiDev: root.devices.find(dev => dev.type === DeviceType.Wifi) ?? null
    property WiredDevice wiredDev: root.devices.find(dev => dev.type === DeviceType.Wired) ?? null
    readonly property string wifiName: root.wifiDev?.networks.values.find(n => n.connected)?.name ?? ""
    readonly property string wiredName: root.wiredDev?.networks.values.find(n => n.connected)?.name ?? ""
    readonly property string wifiStatus: root.wifiDev == null ? "Unavailable" : !Networking.wifiEnabled ? "Disabled" : root.wifiDev.state === ConnectionState.Connected ? "Connected" : root.wifiDev.state === ConnectionState.Connecting ? "Connecting" : "Disconnected"
    readonly property string wiredStatus: root.wiredDev == null ? "Unavailable" : root.wiredDev.state === ConnectionState.Connected ? "Connected" : "Disconnected"

    //wifi row
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 34
        radius: States.tagRounding
        color: Theme.rectcolor

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Text {
                Layout.preferredWidth: 24
                Layout.alignment: Qt.AlignHCenter
                text: "󰖩"
                color: Theme.text1
                font.family: Theme.fontfamily
            }

            Text {
                Layout.fillWidth: true
                text: "Wi-Fi"
                color: Theme.text1
                font.family: Theme.fontfamily
            }

            Text {
                text: root.wifiStatus === "Connected" ? root.wifiStatus + " · " + root.wifiName : root.wifiStatus
                color: root.wifiStatus === "Connected" ? Theme.text1 : Theme.textmuted
                elide: Text.ElideRight
                font.family: Theme.fontfamily
            }
        }
    }

    //ethernet row
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 34
        radius: States.tagRounding
        color: Theme.rectcolor

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Text {
                Layout.preferredWidth: 24
                Layout.alignment: Qt.AlignHCenter
                text: "󰈁"
                color: root.wiredDev?.state === ConnectionState.Connected ? Theme.miconcolor : Theme.text1
                font.family: Theme.fontfamily
            }

            Text {
                Layout.fillWidth: true
                text: "Ethernet"
                color: Theme.text1
                font.family: Theme.fontfamily
            }

            Text {
                text: root.wiredStatus === "Connected" ? root.wiredStatus + " · " + root.wiredName : root.wiredStatus
                color: root.wiredStatus === "Connected" ? Theme.text1 : Theme.textmuted
                elide: Text.ElideRight
                font.family: Theme.fontfamily
            }
        }
    }

    //bluetooth placeholder
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 34
        radius: States.tagRounding
        color: Theme.rectcolor

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Text {
                Layout.preferredWidth: 24
                Layout.alignment: Qt.AlignHCenter
                text: "󰂯"
                color: Theme.text1
                font.family: Theme.fontfamily
            }

            Text {
                Layout.fillWidth: true
                text: "Bluetooth"
                color: Theme.text1
                font.family: Theme.fontfamily
            }

            Text {
                text: BluetoothState.status + BluetoothState.connectedDev
                color: Theme.textmuted
                font.family: Theme.fontfamily
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
