import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import qs.modules
import qs.modules.themeing
import qs.services

Rectangle {
    id: connPage
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: Theme.bgcolor

    //bluetooth action indicator text
    property string btActionText: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
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

        Text {
            visible: connPage.btActionText !== ""
            text: connPage.btActionText
            color: Theme.alertcolor
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        //bluetooth on/off
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            radius: States.itemRounding
            color: Theme.bgcolor
            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    Layout.fillWidth: true
                    text: "Bluetooth"
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                ThemeSwitch {
                    checked: BluetoothState.btEnabled
                    onClicked: BluetoothState.toggleBluetooth()
                }
            }
        }

        //bluetooth devices
        Repeater {
            model: BluetoothState.devices

            delegate: Rectangle {
                id: btDevEntry

                required property var modelData

                Layout.fillWidth: true
                implicitHeight: 70
                radius: States.tagRounding
                color: Theme.rectcolor

                Column {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 2

                    Text {
                        text: btDevEntry.modelData.deviceName
                        color: Theme.text1
                        elide: Text.ElideRight
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontbase
                        }
                    }

                    Text {
                        text: btDevEntry.modelData.connected ? "Connected" : (btDevEntry.modelData.paired ? "Paired" : "Available")
                        color: btDevEntry.modelData.connected ? Theme.miconcolor : Theme.textmuted
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontsm
                        }
                    }

                    RowLayout {
                        spacing: 6

                        Rectangle {
                            visible: !btDevEntry.modelData.paired
                            implicitHeight: 26
                            implicitWidth: 48
                            radius: States.sliderRounding
                            color: Theme.rectcolor
                            border {
                                width: States.borderOn ? 1 : 0
                                color: Theme.bordercolor
                            }
                            Text {
                                anchors.centerIn: parent
                                text: "Pair"
                                color: Theme.text1
                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontsm
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: BluetoothState.pairDevice(btDevEntry.modelData)
                            }
                        }

                        Rectangle {
                            visible: btDevEntry.modelData.paired && !btDevEntry.modelData.connected
                            implicitHeight: 26
                            implicitWidth: 58
                            radius: States.sliderRounding
                            color: Theme.rectcolor
                            border {
                                width: States.borderOn ? 1 : 0
                                color: Theme.bordercolor
                            }
                            Text {
                                anchors.centerIn: parent
                                text: "Connect"
                                color: Theme.text1
                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontsm
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    BluetoothState.connectDevice(btDevEntry.modelData);
                                    connPage.btActionText = "Connecting to " + btDevEntry.modelData.deviceName;
                                }
                            }
                        }

                        Rectangle {
                            visible: btDevEntry.modelData.connected
                            implicitHeight: 26
                            implicitWidth: 58
                            radius: States.sliderRounding
                            color: Theme.rectcolor
                            border {
                                width: States.borderOn ? 1 : 0
                                color: Theme.bordercolor
                            }
                            Text {
                                anchors.centerIn: parent
                                text: "Disconnect"
                                color: Theme.text1
                                font {
                                    family: Theme.fontfamily
                                    pixelSize: Theme.fontsm
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    BluetoothState.disconnectDevice(btDevEntry.modelData);
                                    connPage.btActionText = "Disconnecting from " + btDevEntry.modelData.deviceName;
                                }
                            }
                        }
                    }
                }
            }
        }

        //wifi on/off
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            radius: States.itemRounding
            color: Theme.bgcolor
            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    Layout.fillWidth: true
                    text: "Wi-Fi"
                    color: Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxxl
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                ThemeSwitch {
                    checked: NetworkState.wifiEnabled
                    onClicked: NetworkState.toggleWifi()
                }
            }
        }

        //wifi networks
        Repeater {
            model: NetworkState.wifiNetworks

            delegate: Rectangle {
                id: wifiNetEntry

                required property var modelData

                Layout.fillWidth: true
                implicitHeight: 70
                radius: States.tagRounding
                color: Theme.rectcolor

                Column {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 2

                    Text {
                        text: wifiNetEntry.modelData.name
                        color: Theme.text1
                        elide: Text.ElideRight
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontbase
                        }
                    }

                    Text {
                        text: "Signal: " + Math.round(wifiNetEntry.modelData.signalStrength * 100) + "%"
                        color: Theme.textmuted
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontsm
                        }
                    }

                    Text {
                        text: "Security: " + WifiSecurityType.toString(wifiNetEntry.modelData.security)
                        color: Theme.textmuted
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontsm
                        }
                    }

                    Rectangle {
                        implicitHeight: 26
                        implicitWidth: 78
                        radius: States.sliderRounding
                        color: Theme.rectcolor
                        border {
                            width: States.borderOn ? 1 : 0
                            color: Theme.bordercolor
                        }
                        Text {
                            anchors.centerIn: parent
                            text: "Connect"
                            color: Theme.text1
                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontsm
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: wifiNetEntry.modelData.connect()
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
