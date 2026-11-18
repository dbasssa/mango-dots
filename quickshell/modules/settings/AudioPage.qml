import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules
import qs.modules.themeing
import qs.services

Rectangle {
    id: root

    Layout.fillHeight: true
    Layout.fillWidth: true
    color: Theme.bgcolor

    //mirror of the hardware brightness, updated while the slider moves
    property int brightness: States.brightness

    function applyBrightness(percent) {
        const cmd = Deps.brightnessCommand(percent);
        if (cmd.length === 0)
            return;
        brightnessProc.command = cmd;
        brightnessProc.running = true;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            text: "Audio"
            color: Theme.text1
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontxxl
                bold: true
            }
        }

        //================ output ================
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: outputLayout.implicitHeight + 20
            radius: States.itemRounding
            color: Theme.bgcolor
            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            ColumnLayout {
                id: outputLayout

                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "Output"
                        color: Theme.text1
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxxl
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        Layout.maximumWidth: 380
                        text: Pipewire.sinkReady ? Pipewire.sinkName : "No output"
                        color: Theme.textmuted
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignRight
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontmd
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    //mute
                    Rectangle {
                        implicitWidth: 30
                        implicitHeight: 30
                        radius: States.sliderRounding
                        color: muteMouse.containsMouse ? Theme.recthovercolor : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: Pipewire.muted ? "󰖁" : "󰕾"
                            color: Pipewire.muted ? Theme.alertcolor : Theme.text1
                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontxl
                            }
                        }

                        MouseArea {
                            id: muteMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Pipewire.toggleMute()
                        }
                    }

                    ValueSlider {
                        Layout.fillWidth: true
                        from: Pipewire.minVolume
                        to: Pipewire.maxVolume
                        value: Pipewire.vol
                        enabled: Pipewire.sinkReady
                        onMoved: (v) => Pipewire.setVolume(v)
                    }

                    Text {
                        Layout.preferredWidth: 40
                        text: Pipewire.vol + "%"
                        color: Pipewire.muted ? Theme.textmuted : Theme.text1
                        horizontalAlignment: Text.AlignRight
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontbase
                        }
                    }
                }

                //output devices
                Repeater {
                    model: Pipewire.sinks

                    delegate: Rectangle {
                        id: sinkEntry

                        required property var modelData

                        Layout.fillWidth: true
                        implicitHeight: 32
                        radius: States.sliderRounding
                        color: sinkMouse.containsMouse ? Theme.recthovercolor : (Pipewire.isCurrentSink(sinkEntry.modelData) ? Theme.occupiedcolor : Theme.rectcolor)

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.right: checkIcon.visible ? checkIcon.left : parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            text: Pipewire.nodeLabel(sinkEntry.modelData)
                            color: Theme.text1
                            elide: Text.ElideRight
                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontbase
                            }
                        }

                        Text {
                            id: checkIcon

                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            visible: Pipewire.isCurrentSink(sinkEntry.modelData)
                            text: "󰄬"
                            color: Theme.textactive
                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontbase
                            }
                        }

                        MouseArea {
                            id: sinkMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Pipewire.setDefaultSink(sinkEntry.modelData)
                        }
                    }
                }
            }
        }

        //================ microphone ================
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            radius: States.itemRounding
            color: Theme.bgcolor
            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    text: Pipewire.micMuted ? "󰍭" : "󰍬"
                    color: Pipewire.micMuted ? Theme.alertcolor : Theme.text1
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "Microphone"
                        color: Theme.text1
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxxl
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: Pipewire.micReady ? (Pipewire.micName !== "" ? Pipewire.micName : "Default microphone") : "No microphone detected"
                        color: Theme.textmuted
                        elide: Text.ElideRight
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontsm
                        }
                    }
                }

                Text {
                    text: Pipewire.micMuted ? "Muted" : "On"
                    color: Pipewire.micMuted ? Theme.textmuted : Theme.textactive
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                    }
                }

                ThemeSwitch {
                    checked: Pipewire.micMuted
                    onClicked: Pipewire.toggleMicMute()
                }
            }
        }

        //================ brightness ================
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: brightnessLayout.implicitHeight + 20
            radius: States.itemRounding
            color: Theme.bgcolor
            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            ColumnLayout {
                id: brightnessLayout

                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Brightness"
                        color: Theme.text1
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxxl
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        Layout.preferredWidth: 40
                        text: Deps.probed && !Deps.canSetBrightness ? "--" : root.brightness + "%"
                        color: Theme.text1
                        horizontalAlignment: Text.AlignRight
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontbase
                        }
                    }
                }

                ValueSlider {
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: root.brightness
                    //no usable backend (no internal backlight, no DDC/CI display)
                    enabled: !Deps.probed || Deps.canSetBrightness
                    onMoved: (v) => {
                        root.brightness = v;
                        //keep the OSD in sync while dragging
                        States.brightness = v;
                    }
                    onCommitted: (v) => root.applyBrightness(v)
                }
            }
        }

        Text {
            Layout.fillWidth: true
            visible: !Deps.probed || !Deps.canSetBrightness
            text: "Brightness isn't available on this display."
            color: Theme.textmuted
            wrapMode: Text.WordWrap
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontsm
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    Process {
        id: brightnessProc

        command: []
        running: false
        stdout: StdioCollector {}
        onExited: States.brightness = root.brightness
    }
}
