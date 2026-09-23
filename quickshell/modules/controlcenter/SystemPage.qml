import QtQuick
import QtQuick.Layouts
import qs.modules.themeing

ColumnLayout {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 10

    Text {
        text: "System"
        color: Theme.text1

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontxxl
            bold: true
        }

    }

    RAMMonitor {
        Layout.fillWidth: true
    }

    CPUMonitor {
        Layout.fillWidth: true
    }

    Item {
        Layout.fillHeight: true
    }

}