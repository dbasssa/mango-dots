import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules
import qs.modules.themeing

Rectangle {
    id: root
    visible: States.notchBar ? false : (States.wsVisible ? true : false)
    border {
        width: States.borderOn ? 1 : 0
        color: Theme.bordercolor
    }

    property string monitor: ""

    implicitHeight: Math.round(States.barHeight * 0.75)
    implicitWidth: row.implicitWidth +20
    color: Theme.rectcolor
    radius: States.itemRounding

    ListModel {
        id: tagModel
        ListElement { tag_id: 0; name: ""; layout: ""; is_active: false; client_count: 0 }
    }

    function tagWidth(i) {
        const t = i >= 0 && i < tagModel.count ? tagModel.get(i) : null;
        return t && t.is_active ? 30 : 25
    }
    function activeIndex() {
        for (let i = 0; i < tagModel.count; i++)
            if (tagModel.get(i).is_active) return i;
        return -1;
    }

    function accentX() {
        const idx = root.activeIndex();
        if (idx < 0) return 0;
        let x = 0;
        for (let i = 0; i < idx; i++)
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
                if (obj && obj.tags) {
                    const tags = obj.tags;
                    if (tags.length !== tagModel.count) {
                        tagModel.clear();
                        for (const t of tags)
                            tagModel.append({ tag_id: t.id, name: t.name, layout: t.layout, is_active: t.is_active, client_count: t.client_count });
                    } else {
                        for (let i = 0; i < tags.length; i++) {
                            if (tagModel.get(i).is_active !== tags[i].is_active)
                                tagModel.setProperty(i, "is_active", tags[i].is_active);
                            if (tagModel.get(i).client_count !== tags[i].client_count)
                                tagModel.setProperty(i, "client_count", tags[i].client_count);
                        }
                    }
                }
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
            model: tagModel
            Rectangle {
                id: tag
                implicitHeight: Math.round(States.barHeight * 0.50)
                implicitWidth: model.is_active ? 30 : 20
                radius: States.tagRounding

                color: model.is_active ? Theme.text1 : (model.client_count > 0 ? Theme.occupiedcolor : Theme.recthovercolor)

                Text {
                    property bool fresh
                    anchors.centerIn: parent
                    color: model.is_active ? Theme.bgcolor : Theme.text1

                    onTextChanged: fresh = true
                    font {
                        pixelSize: fresh ? Theme.fontmd * States.fontScale : 0
                        family: Theme.fontfamily
                    }
                    text: model.is_active ? model.layout : model.index + 1
                }

                MouseArea {//MOTHERFUCKER JUST WORK BRO
                    anchors.fill: parent
                    onClicked: {
                        switchWS.command = ["mmsg","dispatch","view,"+ (model.index+1) +",0"];
                        switchWS.running = true;
                    }

                }
                Behavior on implicitWidth {
                    NumberAnimation {
                        easing.type: Easing.OutCubic
                        duration: 300
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        easing.type: Easing.OutCubic
                        duration: 300
                    }
                }
            }
        }
    }

}
