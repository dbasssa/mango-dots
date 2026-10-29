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
    implicitWidth: row.implicitWidth + 20
    color: Theme.rectcolor
    radius: States.itemRounding

    ListModel {
        id: tagModel
        ListElement {
            tag_id: 0
            layout: ""
            is_active: false
            is_urgent: false
            client_count: 0
        }
    }

    // Rebuild the model when the tag set itself changed, otherwise patch only the
    // fields that actually differ. layout MUST be part of the diff, otherwise it
    // stays frozen at whatever the compositor reported on the very first event.
    function syncTags(tags) {
        const sameTags = tags.length === tagModel.count
            && tags.every((t, i) => tagModel.get(i).tag_id === t.index);
        if (!sameTags) {
            tagModel.clear();
            for (const t of tags)
                tagModel.append({
                    tag_id: t.index,
                    layout: t.layout,
                    is_active: t.is_active,
                    is_urgent: t.is_urgent,
                    client_count: t.client_count
                });
            return;
        }
        for (let i = 0; i < tags.length; i++) {
            const cur = tagModel.get(i);
            const t = tags[i];
            if (cur.layout !== t.layout)
                tagModel.setProperty(i, "layout", t.layout);
            if (cur.is_active !== t.is_active)
                tagModel.setProperty(i, "is_active", t.is_active);
            if (cur.is_urgent !== t.is_urgent)
                tagModel.setProperty(i, "is_urgent", t.is_urgent);
            if (cur.client_count !== t.client_count)
                tagModel.setProperty(i, "client_count", t.client_count);
        }
    }

    Process {
        command: ["mmsg", "watch", "tags", root.monitor]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const line = String(data).trim();
                if (line === "")
                    return;
                let obj = null;
                try {
                    obj = JSON.parse(line);
                } catch (e) {
                    return;
                }
                if (obj && obj.tags)
                    root.syncTags(obj.tags);
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
                implicitHeight: Math.round(States.barHeight * 0.50)
                implicitWidth: model.is_active ? 30 : 20
                radius: States.tagRounding

                color: model.is_active ? Theme.text1 : (model.is_urgent ? Theme.alertcolor : (model.client_count > 0 ? Theme.occupiedcolor : Theme.recthovercolor))

                Text {
                    property bool fresh
                    anchors.centerIn: parent
                    color: model.is_active ? Theme.bgcolor : Theme.text1

                    onTextChanged: fresh = true
                    font {
                        pixelSize: fresh ? Theme.fontmd : 0
                        family: Theme.fontfamily
                    }
                    text: model.is_active ? (model.layout || "") : model.index + 1
                }

                MouseArea {//MOTHERFUCKER JUST WORK BRO
                    anchors.fill: parent
                    onClicked: {
                        switchWS.command = ["mmsg", "dispatch", "view," + (model.index + 1) + ",0"];
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
