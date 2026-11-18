import QtQuick
import QtQuick.Layouts
import qs.modules
import qs.modules.themeing

//current theme name in the bar. clicking it opens the theme picker.
Rectangle {
    id: root

    visible: !States.notchBar
    Layout.alignment: Qt.AlignHCenter
    implicitHeight: Math.round(States.barHeight * 0.75)
    implicitWidth: Math.min(180, label.implicitWidth + 18)
    color: themeMouse.containsMouse ? Theme.recthovercolor : Theme.rectcolor
    radius: States.itemRounding
    clip: true

    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    Text {
        id: label

        anchors.centerIn: parent
        width: parent.width - 14
        horizontalAlignment: Text.AlignHCenter
        text: "󰏘 " + ThemeState.themes[ThemeState.themeIndex].name
        color: themeMouse.containsMouse ? Theme.textactive : Theme.textmuted
        elide: Text.ElideRight

        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontsm
        }
    }

    MouseArea {
        id: themeMouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: States.themeOpen = true
    }
}
