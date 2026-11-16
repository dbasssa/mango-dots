import QtQuick

import qs.modules.themeing
import qs.services

Item {
    id: root

    implicitHeight: parent.implicitHeight - 5
    implicitWidth: voltxt.implicitWidth + 10
    anchors.verticalCenter: parent.verticalCenter

    Text {
        id: voltxt

        anchors.centerIn: parent
        text: !Pipewire.sinkReady ? "-" : Pipewire.muted ? "0%" : Pipewire.vol + "% 󰕾"
        color: Pipewire.muted ? Theme.textmuted : Theme.text1
        font.family: Theme.fontfamily
        font.pixelSize: Theme.fontlg
    }
}
