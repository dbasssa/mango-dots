import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell

import qs.modules
import qs.modules.themeing
import qs.services

//contents of one lock screen surface. kept in its own file because
//WlSessionLock instantiates its surface from a component, which has its own id
//scope — the controller is passed in explicitly instead of reaching outward.
Rectangle {
    id: surface

    required property var controller

    color: "transparent"

    //wallpaper, blurred and dimmed so the foreground stays readable
    Image {
        id: wallImg

        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        source: WallpaperState.currentWallpaper
    }

    MultiEffect {
        anchors.fill: parent
        source: wallImg
        blurEnabled: true
        blur: 1
        blurMax: 64
        blurMultiplier: 2
        saturation: 0.9
        brightness: -0.08
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.35)
    }

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    ColumnLayout {
        id: content

        anchors.centerIn: parent
        width: Math.min(560, parent.width - 64)
        spacing: 16

        //clock + date
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 0

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDateTime(clock.date, "hh:mm")
                color: Theme.text1

                font {
                    family: Theme.fontfamily
                    pixelSize: 76
                    bold: true
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDateTime(clock.date, "dddd, d MMMM yyyy")
                color: Theme.textmuted

                font {
                    family: Theme.fontfamily
                    pixelSize: Theme.fontxl
                }
            }
        }

        LockStatus {
            Layout.alignment: Qt.AlignHCenter
        }

        LockMedia {
            Layout.fillWidth: true
        }

        //pending notifications — count only, contents need unlocking
        Rectangle {
            Layout.fillWidth: true
            visible: NotificationState.trackedCount > 0
            implicitHeight: 46
            radius: States.itemRounding
            color: Theme.rectcolor

            border {
                width: States.borderOn ? 1 : 0
                color: Theme.bordercolor
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 10

                Text {
                    //md-bell
                    text: "\uDB80\uDC9A"
                    color: Theme.textactive

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: NotificationState.trackedCount + (NotificationState.trackedCount === 1 ? " Notification" : " Notifications") + ", unlock to view"
                    color: Theme.text1
                    elide: Text.ElideRight

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                    }
                }
            }
        }

        //login card
        Rectangle {
            id: loginCard

            Layout.fillWidth: true
            implicitHeight: loginCol.implicitHeight + 36
            radius: States.panelRounding
            color: Theme.rectcolor

            border {
                width: States.borderOn ? 2 : 0
                color: Theme.bordercolor
            }

            ColumnLayout {
                id: loginCol

                x: 18
                y: 18
                width: parent.width - 36
                spacing: 10

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: 58
                    implicitHeight: 58
                    radius: 29
                    color: Theme.recthovercolor

                    border {
                        width: States.borderOn ? 1 : 0
                        color: Theme.bordercolor
                    }

                    Text {
                        anchors.centerIn: parent
                        //md-account
                        text: "\uDB80\uDC04"
                        color: Theme.textmuted

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontxxl
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: surface.controller.userN !== "" ? surface.controller.userN : "lock screen"
                    color: Theme.text1

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontxl
                        bold: true
                    }
                }

                Rectangle {
                    id: fieldBox

                    property int focusTries: 0

                    Layout.fillWidth: true
                    implicitHeight: 46
                    color: Theme.recthovercolor
                    radius: States.itemRounding

                    border {
                        width: 2
                        color: passwdField.activeFocus ? Theme.textactive : Theme.bordercolor
                    }

                    TextField {
                        id: passwdField

                        anchors.fill: parent
                        leftPadding: 16
                        rightPadding: 50
                        color: Theme.text1
                        echoMode: TextInput.Password
                        inputMethodHints: Qt.ImhSensitiveData
                        placeholderText: "Password"
                        placeholderTextColor: Theme.textmuted
                        focus: true
                        enabled: !surface.controller.pamActive && !surface.controller.lockedOut
                        selectByMouse: true
                        background: null
                        onAccepted: surface.controller.submit(passwdField.text)
                        onTextChanged: {
                            if (surface.controller.passwordText !== passwdField.text)
                                surface.controller.passwordText = passwdField.text;
                            surface.controller.showFailure = false;
                        }
                        onEnabledChanged: if (enabled)
                            forceActiveFocus()

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontlg
                        }
                    }

                    //keyboard Enter also submits; this gives mouse users a
                    //target and restores focus after a failed attempt
                    Item {
                        anchors.right: parent.right
                        anchors.rightMargin: 7
                        anchors.verticalCenter: parent.verticalCenter
                        implicitWidth: 32
                        implicitHeight: 32
                        opacity: passwdField.text.length > 0 && !surface.controller.pamActive && !surface.controller.lockedOut ? 1 : 0.35

                        Text {
                            anchors.centerIn: parent
                            //cod-unlock
                            text: "\uEB74"
                            color: unlockMouse.containsMouse ? Theme.miconcolor : Theme.textmuted

                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontlg
                            }
                        }

                        MouseArea {
                            id: unlockMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: passwdField.text.length > 0 && !surface.controller.pamActive && !surface.controller.lockedOut
                            onClicked: surface.controller.submit(passwdField.text)
                        }
                    }

                    //the controller cannot reach into this component, so both
                    //directions are mirrored through its properties
                    Connections {
                        target: surface.controller

                        function onPasswordTextChanged() {
                            if (passwdField.text !== surface.controller.passwordText)
                                passwdField.text = surface.controller.passwordText;
                        }

                        function onFocusTickChanged() {
                            fieldBox.focusTries = 0;
                            focusTimer.restart();
                        }
                    }

                    //the lock window can take a moment to become keyboard
                    //active, so retry focus for a couple of seconds
                    Timer {
                        id: focusTimer

                        interval: 250
                        repeat: true
                        running: true
                        triggeredOnStart: true
                        onTriggered: {
                            passwdField.forceActiveFocus();
                            if (++fieldBox.focusTries >= 8)
                                stop();
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    visible: InputState.capsLock
                    //md-caps_lock
                    text: "\uDB82\uDE9B Caps Lock is on"
                    color: Theme.alertcolor

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                        bold: true
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    visible: surface.controller.showFailure || surface.controller.lockedOut
                    text: surface.controller.lockedOut ? "Too many attempts — try again in " + surface.controller.lockRemaining + "s" : "Incorrect password"
                    color: Theme.alertcolor

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    visible: !surface.controller.showFailure && !surface.controller.lockedOut && !InputState.capsLock
                    text: "Press Enter to unlock"
                    color: Theme.textmuted

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontsm
                    }
                }
            }
        }

        LockBattery {
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
