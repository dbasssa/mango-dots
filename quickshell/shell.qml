import QtQuick
import QtQuick.Layouts
import Quickshell

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {}

    }

    Variants {
        model: Quickshell.screens

        //ScreenFrame {}

    }

    Variants {
        model: Quickshell.screens

        Wallpaper{}
    }

    Notifications {}

    Variants {
        model: Quickshell.screens

        OutsideClickCatcher {}

    }

    CtrlCenter {}

    WallpaperPicker {}

    ThemePicker {}
    AppLauncher {}

}
