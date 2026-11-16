import QtQuick
import QtQuick.Layouts

import qs.modules
import qs.modules.themeing
import qs.services

//quiet status strip under the lock screen clock
Rectangle {
    id: root

    readonly property bool showCaps: InputState.capsLock
    readonly property bool showMic: Pipewire.micMuted
    readonly property bool showOut: Pipewire.muted
    readonly property bool showDnd: NotificationState.dnd
    readonly property bool showBattery: Battery.exists
    readonly property bool showBluetooth: BluetoothState.btEnabled && BluetoothState.connectedDev.length > 0
    readonly property bool showNetwork: NetworkState.wifiDev !== null || NetworkState.wiredDev !== null
    readonly property bool showLayout: InputState.layoutLabel !== ""

    readonly property bool anything: root.showCaps || root.showMic || root.showOut || root.showDnd || root.showBattery || root.showBluetooth || root.showNetwork || root.showLayout

    visible: root.anything
    implicitWidth: row.implicitWidth + 22
    implicitHeight: Math.round(States.barHeight * 0.9)
    radius: States.itemRounding
    color: Theme.rectcolor

    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: 12

        Text {
            visible: root.showCaps
            //md-caps_lock
            text: "\uDB82\uDE9B CAPS"
            color: Theme.alertcolor

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontmd
                bold: true
            }
        }

        Text {
            visible: root.showMic
            //md-microphone_off
            text: "\uDB80\uDF6D"
            color: Theme.alertcolor

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        Text {
            visible: root.showOut
            //md-volume_off
            text: "\uDB81\uDD81"
            color: Theme.alertcolor

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        Text {
            visible: root.showDnd
            //fa-bell_slash
            text: "\uF1F6"
            color: Theme.textactive

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        Text {
            visible: root.showBluetooth
            //md-bluetooth
            text: "\uDB80\uDCAF"
            color: Theme.textactive

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        Text {
            visible: root.showNetwork
            Layout.maximumWidth: 170
            elide: Text.ElideRight
            text: NetworkState.activeIcon.trim() + " " + (NetworkState.wiredConnected ? (NetworkState.wiredName || "Ethernet") : NetworkState.wifiConnected ? (NetworkState.wifiName || "Wi-Fi") : "Offline")
            color: NetworkState.activeConnected ? Theme.text1 : Theme.textmuted

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontmd
            }
        }

        Text {
            visible: root.showBattery
            text: Battery.get_Battery_Icon() + " " + Battery.percentage + "%"
            color: Battery.isCharging ? Theme.miconcolor : (Battery.percentage > 20 ? Theme.text1 : Theme.alertcolor)

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontmd
            }
        }

        Text {
            visible: root.showLayout
            text: InputState.layoutLabel
            color: Theme.textmuted

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontmd
            }
        }
    }
}
