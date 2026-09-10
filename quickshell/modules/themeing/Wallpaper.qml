import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    required property var modelData
    property string activeWall: ""
    property string pendingUrl: ""
    property bool transitioning: false

    function startSwap(url) {
        if (!url || url === root.activeWall)
            return ;

        if (root.transitioning)
            root.finalize(root.pendingUrl);

        root.transitioning = true;
        root.pendingUrl = url;
        imgB.source = url;
        if (imgB.status === Image.Ready)
            root.runTransition();

    }

    function runTransition() {
        imgA.opacity = 1;
        imgB.opacity = 0;
        imgB.scale = 0.5;
        swapAnim.restart();
    }

    function finalize(url) {
        swapAnim.stop()
        root.activeWall = url
        root.pendingUrl = ""
        root.transitioning = false
        imgA.source = url
        imgA.opacity = 1
        imgB.opacity = 0
        imgB.scale = 1
        imgB.source = ""
    }

    Connections {
        target: WallpaperState
        function onCurrentWallpaperChanged() {
            root.startSwap(WallpaperState.currentWallpaper)
        }
    }

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
        id: imgA

        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        source: root.activeWall
        opacity: 1
    }

    Image {
        id: imgB

        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        source: ""
        opacity: 0
        scale: 0.5
        onStatusChanged: {
            if (root.transitioning && root.pendingUrl !== root.activeWall) {
                if (status === Image.Ready)
                    root.runTransition();
                else if (status === Image.Error)
                    root.finalize(root.pendingUrl);
            }
        }
    }

    ParallelAnimation {
        id: swapAnim

        NumberAnimation {
            target: imgB
            property: "opacity"
            to: 1
            duration: 600
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: imgB
            property: "scale"
            to: 1
            duration: 700
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: imgA
            property: "opacity"
            to: 0
            duration: 1000
            easing.type: Easing.OutCubic
        }

        onFinished: root.finalize(root.pendingUrl)
    }

}
