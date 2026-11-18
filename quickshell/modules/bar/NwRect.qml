import QtQuick
import QtQuick.Layouts

import qs.modules.themeing
import qs.services

Item {
    id: root

    Layout.alignment: Qt.AlignVCenter
    implicitHeight: parent.implicitHeight - 5
    implicitWidth: wiredTxt.visible ? wiredTxt.implicitWidth + 10 : wifiTxt.implicitWidth + 10

    //wifi network
    Text {
        id: wifiTxt

        visible: NetworkState.wifiDev != null
        anchors.centerIn: parent
        text: NetworkState.wifiName + NetworkState.wifiIcon
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontlg
        }
    }

    //wired network
    Text {
        id: wiredTxt

        anchors.centerIn: parent
        visible: NetworkState.wiredDev != null
        text: NetworkState.wiredName + NetworkState.wiredIcon
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontlg
        }
    }
}
