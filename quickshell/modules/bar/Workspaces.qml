import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing

Rectangle {
    id: root
    visible: States.notchBar ? false : (States.wsVisible ? true : false)
    

    property string monitor: ""

    implicitHeight: 25
    implicitWidth: row.implicitWidth +20
    color: Theme.rectcolor
    radius: 20

    property var tagModel: []

    function tagWidth(i) {
        return root.tagModel[i] && root.tagModel[i].is_active ? 30 : 25
    }
    function activeIndex() {
        for (let i = 0; i < root.tagModel.length; i++)
            if (root.tagModel[i].is_active) return i;
        return -1;
    }

    function accentX() {
        const idx = root.activeIndex();
        if (idx < 0) return 0;
        let x = 0; 
        for (let i = 0 ; i < idx; i++) 
            x += root.tagWidth(i) + row.spacing;
        return x;
    }

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
    Process {
        id: switchWS
        command: [""]
        running: false
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
                id: tag
                implicitHeight: 15
                implicitWidth: modelData.is_active ? 30 : 25
                radius: 10

                color: modelData.client_count > 0 ? Theme.text1 : Theme.recthovercolor

                Text {
                    anchors.centerIn: parent
                    color: modelData.client_count > 0 ? Theme.bgcolo : Theme.text1

                    font {
                        pixelSize: Theme.fontmd
                        family: Theme.fontfamily
                    }
                    text: modelData.is_active ? modelData.layout : model.index + 1
                }

                MouseArea {//MOTHERFUCKER JUST WORK BRO
                    anchors.fill: parent
                    onClicked: {
                        switchWS.command = ["mmsg","dispatch","view,"+ (model.index+1) +",0"];
                        switchWS.running = true;
                    }

                }
            }
        }
    }
    Rectangle {
        id: accent
        visible: root.activeIndex() >= 0
        color: Theme.textactive
        height: 3
        radius: 1.5
        width: 20
        anchors.bottom: row.bottom
        anchors.bottomMargin: 4
        x: 12 + root.accentX()
        Behavior on x { NumberAnimation { duration: 260; easing.type: Easing.InOutCubic } }
        Behavior on width { NumberAnimation { duration: 260; easing.type: Easing.InOutCubic } }
    }

}
