import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules
import qs.modules.themeing

Rectangle {
    id: root

    Layout.fillHeight: true
    Layout.fillWidth: true
    color: Theme.bgcolor

    //keep every field inside the documented 0..20 range
    function applyField(field, lock) {
        const v = parseInt(field.text);
        if (isNaN(v)) {
            field.text = String(lock ? Idle.lockMinutes : Idle.sleepMinutes);
            return;
        }
        const clamped = Math.max(0, Math.min(20, v));
        if (lock)
            Idle.lockMinutes = clamped;
        else
            Idle.sleepMinutes = clamped;
        field.text = String(clamped);
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            text: "Timers"
            color: Theme.text1
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontxxl
                bold: true
            }
        }

        Text {
            Layout.fillWidth: true
            text: "Lock or suspend the session after a period of inactivity. Set a value to 0 to disable that action."
            color: Theme.textmuted
            wrapMode: Text.WordWrap
            font {
                family: Theme.fontfamily
                pixelSize: Theme.fontlg
            }
        }

        //lock timer
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

                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "Lock screen"
                        color: Theme.text1
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxxl
                        }
                    }
                    Text {
                        text: "0 disables auto-lock"
                        color: Theme.textmuted
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontsm
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                TextField {
                    id: lockField
                    implicitHeight: 44
                    implicitWidth: 70
                    horizontalAlignment: Text.AlignHCenter
                    text: Idle.lockMinutes
                    color: Theme.text1
                    validator: IntValidator {
                        bottom: 0
                        top: 20
                    }
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                    background: Rectangle {
                        color: Theme.rectcolor
                        radius: States.tagRounding
                    }
                    onAccepted: root.applyField(lockField, true)
                    onEditingFinished: root.applyField(lockField, true)
                }

                Text {
                    text: "min"
                    color: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                    }
                }
            }
        }

        //suspend timer
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

                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "Suspend"
                        color: Theme.text1
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxxl
                        }
                    }
                    Text {
                        text: "0 disables auto-suspend"
                        color: Theme.textmuted
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontsm
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                TextField {
                    id: sleepField
                    implicitHeight: 44
                    implicitWidth: 70
                    horizontalAlignment: Text.AlignHCenter
                    text: Idle.sleepMinutes
                    color: Theme.text1
                    validator: IntValidator {
                        bottom: 0
                        top: 20
                    }
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                    background: Rectangle {
                        color: Theme.rectcolor
                        radius: States.tagRounding
                    }
                    onAccepted: root.applyField(sleepField, false)
                    onEditingFinished: root.applyField(sleepField, false)
                }

                Text {
                    text: "min"
                    color: Theme.textmuted
                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                    }
                }
            }
        }

        //inhibitor bypass
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

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "Ignore idle inhibitors"
                        color: Theme.text1
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxxl
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: "Lock even while a video or media player asks the compositor to stay awake."
                        color: Theme.textmuted
                        wrapMode: Text.WordWrap
                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontsm
                        }
                    }
                }

                ThemeSwitch {
                    checked: Idle.ignoreInhibitors
                    onClicked: Idle.ignoreInhibitors = checked
                }
            }
        }

        Text {
            Layout.fillWidth: true
            text: "This applies to the lock timer only. MangoWM cannot ignore inhibitors for a single app."
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
}
