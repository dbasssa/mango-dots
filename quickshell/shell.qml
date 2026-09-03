import QtQuick
import QtQuick.Layouts
import Quickshell

//Folder imports
import "modules"
import "modules/launcher"
import "modules/bar"
import "modules/controlcenter"
import "modules/systemmonitor"
import "modules/settings"
import "modules/lockscreen"
import "modules/themeing"


ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {}

    }

    Variants {
        model: Quickshell.screens

        ScreenFrame {}

    }

    Variants {
        model: Quickshell.screens

        Wallpaper{}
    }

    Notifications {}
    AppLauncher {}
    Settings {}
    Lockscreen {}
    ActivateLinux {}
    CtrlCenter{}
    SysMon {}

}
