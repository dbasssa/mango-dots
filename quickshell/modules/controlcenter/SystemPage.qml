import QtQuick
import QtQuick.Layouts
import qs.modules
import qs.modules.themeing
import qs.services

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

    Rectangle {
        id: shotBtn

        Layout.fillWidth: true
        implicitHeight: 34
        radius: States.tagRounding
        color: shotMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor

        border {
            width: States.borderOn ? 1 : 0
            color: Theme.bordercolor
        }

        Text {
            anchors.centerIn: parent
            text: Screenshot.active ? "Select a region…" : "Screenshot region"
            color: Theme.text1

            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontmd
            }
        }

        MouseArea {
            id: shotMouse

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Screenshot.region()
        }
    }

    Text {
        Layout.fillWidth: true
        visible: Screenshot.lastError !== "" || Screenshot.lastPath !== ""
        text: Screenshot.lastError !== "" ? Screenshot.lastError : "Saved: " + Screenshot.lastPath.split("/").pop()
        color: Screenshot.lastError !== "" ? Theme.alertcolor : Theme.textmuted
        elide: Text.ElideMiddle

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontsm
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
