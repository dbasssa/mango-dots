import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    exclusionMode: ExclusionMode.Ignore
    property bool animOpen: false
    visible: animOpen
    implicitHeight: 500
    implicitWidth: 380
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
        top: true
        right: true
    }

    margins {
        top: 47
        right: 8
    }

    Connections {
        target: CtrlCenterState
        function onCtrlOpenChanged() {
            if (CtrlCenterState.ctrlOpen) {
                root.animOpen = true
                Qt.callLater(panelIn.start)
            } else {
                panelOut.start()
            }
        }
    }

    Rectangle {
        id: panelBody
        anchors.fill: parent
        color: Theme.rectcolor
        radius: 12
        opacity: 0
        scale: 0.97
        transform: Translate { id: panelT; y: -14 }

        border {
            width: 2
            color: Theme.bordercolor
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.centerIn:parent
            anchors.topMargin: 12
            spacing: 50

            Mpris {
            }
            VolumeCtrl{}
            BrightnessCtl{}

            Item {
                Layout.preferredHeight: 40
                Layout.fillWidth: true

                Rectangle {
                    anchors.fill:parent
                    radius: 8
                    color: wallBtn.containsMouse ? Theme.recthovercolor : Theme.rectcolor
                    border {
                        color: Theme.bordercolor
                        width:1
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "Wallpaper"
                        color: Theme.text1
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontmd

                        }
                    }
                }
                MouseArea {
                    id:wallBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        CtrlCenterState.ctrlOpen = false
                        WallpaperState.pickerOpen = true
                        
                    }
                }
            }
            Item { Layout.fillHeight: true}
        }

    }

    ParallelAnimation {
        id: panelIn
        NumberAnimation { target: panelBody; property: "opacity"; to: 1; duration: 200; easing.type: Easing.OutCubic }
        NumberAnimation { target: panelT; property: "y"; to: 0; duration: 240; easing.type: Easing.OutCubic }
        NumberAnimation { target: panelBody; property: "scale"; to: 1; duration: 200; easing.type: Easing.OutCubic }
    }

    SequentialAnimation {
        id: panelOut
        ParallelAnimation {
            NumberAnimation { target: panelBody; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InCubic }
            NumberAnimation { target: panelT; property: "y"; to: -14; duration: 170; easing.type: Easing.InCubic }
            NumberAnimation { target: panelBody; property: "scale"; to: 0.97; duration: 150; easing.type: Easing.InCubic }
        }
        ScriptAction { script: root.animOpen = false }
    }

}
