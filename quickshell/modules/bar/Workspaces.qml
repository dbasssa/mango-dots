import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing

Rectangle {
    id: root
    visible: States.notchBar ? false : true

    property string monitor: ""

    implicitHeight: 30
    implicitWidth: 220
    color: Theme.rectcolor
    radius: 20

    property var tagModel: []

    Process {
        id: getWorkspaceInfo

        command: ["mmsg", "watch", "tags", root.monitor]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                const line = String(data).trim();
                if (line === "") return; 
                let obj=null; 
                try {obj = JSON.parse(line); } catch(e) {return;}
                if (obj && obj.tags) root.tagModel = obj.tags
            }
        }
    }

    RowLayout {
        id: row

        anchors.fill: parent
        anchors.leftMargin: 7
        anchors.rightMargin: 7
        spacing: 4

        Repeater {
            model: root.tagModel
            Rectangle {
                implicitHeight: 18
                implicitWidth: 18
                radius: 9

                color: modelData.is_active ? Theme.textactive : (modelData.client_count > 0 ? Theme.textmuted : Theme.recthovercolor)

                Text {
                    anchors.centerIn: parent
                    color: modelData.is_active ? Theme.bgcolor : Theme.text1

                    font {
                        pixelSize: Theme.fontmd
                        family: Theme.fontfamily
                    }
                    text: modelData.is_active ? modelData.layout : ""
                }
            }
        }
    }

}
