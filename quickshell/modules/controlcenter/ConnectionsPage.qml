import QtQuick
import QtQuick.Layouts
import qs.modules
import qs.modules.themeing
import qs.services

Item {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true

    //the page content height — the control center panel sizes itself from this
    implicitHeight: flow.implicitHeight

    ColumnLayout {
        id: flow

        anchors.fill: parent
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

        //active network row
        Rectangle {
            id: netBtn

            Layout.fillWidth: true
            implicitHeight: 40
            radius: States.tagRounding
            color: Theme.rectcolor
            opacity: NetworkState.activeConnected ? 1 : 0.45

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
                    text: NetworkState.activeIcon
                    color: NetworkState.activeConnected ? Theme.miconcolor : Theme.text1
                    font.family: Theme.fontfamily
                }

                Text {
                    text: NetworkState.activeLabel
                    color: Theme.text1
                    font.family: Theme.fontfamily
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: NetworkState.activeConnected ? NetworkState.activeStatus + " · " + NetworkState.activeDetail : NetworkState.activeStatus
                    color: NetworkState.activeConnected ? Theme.text1 : Theme.textmuted
                    elide: Text.ElideRight
                    font.family: Theme.fontfamily
                }
            }
        }

        //bluetooth row
        Rectangle {
            id: btBtn

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
                    text: "Bluetooth"
                    color: Theme.textmuted
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontbase
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: {
                        var status = BluetoothState.status;
                        var devs = BluetoothState.connectedDev;
                        var names = [];
                        for (var i = 0; i < devs.length; i++) {
                            if (devs[i]?.deviceName)
                                names.push(devs[i].deviceName);
                        }
                        var detail = "";
                        if (names.length > 1) {
                            detail = names.length + " devices";
                        } else if (names.length === 1) {
                            detail = names[0];
                        }
                        return status + (detail !== "" ? " · " + detail : "");
                    }
                    color: Theme.textmuted
                    elide: Text.ElideRight
                    font.family: Theme.fontfamily
                    font.pixelSize: Theme.fontbase
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
