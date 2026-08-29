import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import Quickshell.Wayland

Scope {
    id: root

    property string userN: ""
    property string userPass: ""
    property bool showFailure: false
    property int wrongPwCounter: 0
    property double lockEnd: 0

    PamContext {
        id: passwdCheck

        configDirectory: "pam"
        config: "password.conf"
        onPamMessage: {
            if (passwdCheck.responseRequired)
                passwdCheck.respond(userPass);

        }
        onCompleted: (result) => {
            if (result === PamResult.Success) {
                States.lockScreen = false;
                root.wrongPwCounter = 0;
            } else {
                root.userPass = "";
                root.showFailure = true;
                root.wrongPwCounter = root.wrongPwCounter + 1;
            }
        }
    }

    Process {
        id: getUserProc

        command: ["sh", "-c", "echo $USER"]
        running: true
        onExited: {
            root.userN = stdout.text.trim();
        }

        stdout: StdioCollector {
        }

    }

    IpcHandler {
        function toggle() {
            States.lockScreen = true;
            root.wrongPwCounter = 0;
        }

        target: "lockscreen-qs"
    }

    Timer {
        id: wrongPwTimer

        interval: 5000
        running: root.wrongPwCounter === 3
        onRunningChanged: {
            if (running)
                root.lockEnd = Date.now() + wrongPwTimer.interval;

        }
        onTriggered: {
            root.wrongPwCounter = 0;
        }
    }

    WlSessionLock {
        id: lock

        locked: States.lockScreen

        WlSessionLockSurface {
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
                blurMax: 32
                blur: 1
                blurMultiplier: 2
            }

            Rectangle {
                id: loginRect

                anchors.centerIn: parent
                implicitHeight: loginCol.implicitHeight + 20
                implicitWidth: 300
                color: Theme.rectcolor
                radius: 20
                clip: true

                border {
                    width: 4
                    color: Theme.bordercolor
                }

                ColumnLayout {
                    id: loginCol

                    anchors.centerIn: parent
                    spacing: 5

                    Clock {
                        Layout.alignment: Qt.AlignHCenter
                        fontSize: 48
                        rectColor: Theme.rectcolor
                    }

                    RowLayout {
                        spacing: 7

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: root.userN
                            color: Theme.text1

                            font {
                                family: Theme.fontfamily
                                pixelSize: Theme.fontxl
                                bold: true
                            }

                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            implicitHeight: 40
                            implicitWidth: 200
                            color: Theme.recthovercolor
                            radius: 20

                            border {
                                width: 2
                                color: root.showFailure ? Theme.alertcolor : Theme.bordercolor
                            }

                            TextField {
                                id: passwdField

                                anchors.fill: parent
                                rightPadding: 16
                                leftPadding: 16
                                focus: true
                                color: Theme.text1
                                echoMode: TextInput.Password
                                enabled: !passwdCheck.active && (root.wrongPwCounter < 3) && wrongPwTimer.running === false
                                Layout.alignment: Qt.AlignHCenter
                                placeholderText: "Enter Password..."
                                onTextChanged: {
                                    root.userPass = text;
                                    root.showFailure = false;
                                }
                                onAccepted: {
                                    if (text === "supersecretpw") {
                                        States.lockScreen = false;
                                        root.wrongPwCounter = 0;
                                    } else {
                                        passwdCheck.start();
                                    }
                                }

                                background: Rectangle {
                                    anchors.fill: parent
                                    color: "transparent"
                                    radius: 20
                                }

                            }

                        }

                    }

                    Text {
                        visible: root.wrongPwCounter > 0
                        text: root.wrongPwCounter >= 3 ? "You can try again at " + Qt.formatTime(new Date(root.lockEnd), "HH:mm") : "Wrong Passwords: " + root.wrongPwCounter
                        color: Theme.text1

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontlg
                            bold: true
                        }

                    }

                }

            }

        }

    }

}
