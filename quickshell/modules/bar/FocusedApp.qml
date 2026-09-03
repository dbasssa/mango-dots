import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing

Rectangle {
    id: root
    clip: true

    visible: States.notchBar ? false : true
    property string focusedApp: ""
    property string focusedTitle: ""
    implicitHeight: 25
    implicitWidth: appTxt.implicitWidth + 20
    Layout.alignment: Qt.AlignVCenter

    color: Theme.rectcolor
    radius: 12

    Text {
        id: appTxt
        anchors.centerIn: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 2
        anchors.bottomMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        color: Theme.text1
        text: root.focusedApp
        font {
            family: Theme.fontfamily
            pixelSize: Theme.fontxl
            

            bold: true
        }
    }

    Process {
        id: getFocusedApp

        command: ["mmsg", "watch", "focusing-client"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                const line = String(data).trim();
                if (line === "")
                    return ;

                let obj = null;
                try {
                    obj = JSON.parse(line);
                } catch (e) {
                    console.log("PARSE FAIL: ", e);
                    return ;
                }
                if (obj && obj.appid && obj.appid !== ""){
                    root.focusedApp = obj.appid;
                }else if (obj.appid === ""){
                    root.focusedApp = "Desktop"
                }
                if (obj && obj.title && obj.title !== "")
                    root.focusedTitle = obj.title;

            }
        }

    }

}
