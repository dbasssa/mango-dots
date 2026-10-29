import QtQuick
import QtQuick.Controls
import qs.modules.themeing

Switch {
    id: control

    implicitWidth: 64
    implicitHeight: 36
    padding: 4
    hoverEnabled: true

    background: Rectangle {
        radius: 8
        color: control.down ? Theme.recthovercolor : "transparent"
        opacity: control.enabled ? 1.0 : 0.4
    }

    indicator: Rectangle {
        implicitWidth: 56
        implicitHeight: 28
        x: control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        radius: height / 2

        color: control.checked ? (control.down ? Theme.occupiedcolor : Theme.textactive) : (control.hovered ? Theme.recthovercolor : Theme.rectcolor)

        border.width: control.visualFocus ? 2 : 1
        border.color: control.visualFocus ? Theme.textactive : Theme.bordercolor
        opacity: control.enabled ? 1.0 : 0.4

        Rectangle {
            width: 22
            height: 22
            radius: width / 2

            x: Math.max(0, Math.min(parent.width - width, control.visualPosition * (parent.width - width)))
            y: (parent.height - height) / 2

            color: control.checked ? Theme.bgcolor : Theme.textmuted
            border.width: control.visualFocus ? 2 : 1
            border.color: control.visualFocus ? Theme.textactive : Theme.bordercolor

            Behavior on x {
                enabled: !control.down
                NumberAnimation {
                    duration: 140
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    contentItem: Item {}
}
