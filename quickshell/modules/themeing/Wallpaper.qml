import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property var modelData

    screen: modelData
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Bottom

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Image {
        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        source: WallpaperState.currentWallpaper
    }

}