import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import Quickshell.Wayland

import qs.modules
import qs.services

Scope {
    id: root

    property string userN: ""
    property string userPass: ""
    //mirrors the text field. the surface is a separate component scope, so the
    //password cannot be read from here directly — it is kept in sync both ways.
    property string passwordText: ""
    property bool showFailure: false
    property int failures: 0
    property double lockUntil: 0
    property int lockRemaining: 0
    //bumped whenever the field should be focused again after a failed attempt
    property int focusTick: 0

    readonly property bool lockedOut: root.lockRemaining > 0
    //the surface cannot see the PamContext directly (separate component scope)
    readonly property bool pamActive: passwdCheck.active

    function resetAuth() {
        root.userPass = "";
        root.passwordText = "";
        root.showFailure = false;
        root.failures = 0;
        root.lockUntil = 0;
        root.lockRemaining = 0;
    }

    function submit(text) {
        if (passwdCheck.active || root.lockedOut)
            return ;
        if (text === undefined || text === null)
            text = root.passwordText;
        if (text.length === 0)
            return ;
        root.userPass = text;
        root.passwordText = text;
        root.showFailure = false;
        passwdCheck.start();
    }

    function startLockout() {
        root.lockUntil = Date.now() + 60000;
        root.lockRemaining = 60;
    }

    PamContext {
        id: passwdCheck

        configDirectory: Quickshell.shellDir + "/pam"
        config: "password.conf"

        onPamMessage: {
            if (passwdCheck.responseRequired)
                passwdCheck.respond(root.userPass);
        }
        onError: error => console.warn("lock screen: pam error:", PamError.toString(error))
        onCompleted: result => {
            root.userPass = "";
            root.passwordText = "";
            if (result === PamResult.Success) {
                root.resetAuth();
                States.lockScreen = false;
            } else {
                root.showFailure = true;
                root.failures = root.failures + 1;
                if (root.failures >= 3)
                    root.startLockout();
                root.focusTick = root.focusTick + 1;
            }
        }
    }

    Process {
        id: getUserProc

        command: ["sh", "-c", "echo $USER"]
        running: true
        onExited: root.userN = stdout.text.trim()

        stdout: StdioCollector {}
    }

    IpcHandler {
        function toggle() {
            States.lockScreen = true;
            root.resetAuth();
        }

        target: "lockscreen-qs"
    }

    Timer {
        id: lockTimer

        interval: 1000
        repeat: true
        running: root.lockRemaining > 0
        onTriggered: {
            const left = Math.ceil((root.lockUntil - Date.now()) / 1000);
            root.lockRemaining = left > 0 ? left : 0;
            if (left <= 0) {
                root.failures = 0;
                root.showFailure = false;
                root.focusTick = root.focusTick + 1;
            }
        }
    }

    Connections {
        target: States

        function onLockScreenChanged() {
            if (States.lockScreen)
                root.resetAuth();
        }
    }

    WlSessionLock {
        id: lock

        locked: States.lockScreen

        WlSessionLockSurface {
            color: "black"

            LockSurface {
                anchors.fill: parent
                controller: root
            }
        }
    }
}
