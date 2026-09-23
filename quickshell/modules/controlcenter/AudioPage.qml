import QtQuick
import QtQuick.Layouts
import qs.modules.themeing

ColumnLayout {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 10

    Mpris {
        Layout.fillWidth: true
    }

    VolumeCtrl {
        Layout.fillWidth: true
    }

    Item {
        Layout.fillHeight: true
    }

}