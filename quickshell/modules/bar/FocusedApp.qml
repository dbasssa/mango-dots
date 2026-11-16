import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules
import qs.modules.themeing
import qs.services

Rectangle {
    id: root
    clip: true

    visible: States.notchBar ? false : (States.appsVisible ? true : false)
    property string focusedApp: Mmsg.focusedApp
    property string focusedTitle: Mmsg.focusedTitle
    implicitHeight: Math.round(States.barHeight * 0.75)
    implicitWidth: Math.min(200, appTxt.implicitWidth + 20)

    Layout.alignment: Qt.AlignVCenter

    color: Theme.rectcolor
    radius: States.itemRounding

    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    Text {
        id: appTxt
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.topMargin: 2
        anchors.bottomMargin: 2
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        color: Theme.text1
        text: root.focusedTitle !== "" ? root.focusedTitle : root.focusedApp
        elide: Text.ElideRight
        width: parent.width - 20
        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontxl
            bold: true
        }
    }
}
