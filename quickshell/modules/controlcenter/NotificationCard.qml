import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.modules
import qs.modules.themeing

//shared notification card, used by the popup layer (Notifications.qml),
//the control center history page (NotificationsPage.qml) and the
//lockscreen (Lockscreen.qml). Renders image/summary/body/app plus the
//notification's actions as clickable buttons while it is still open.
Rectangle {
    id: card

    //live Quickshell.Services.Notifications notification object
    property var notification: null
    //timestamp shown next to the summary, hidden when empty
    property string timeLabel: ""
    //hide after States.notifTimeout unless critical (popup + lockscreen)
    property bool autoTimeout: false
    //render action buttons (off on the lockscreen)
    property bool showActions: true
    //highlight the card on hover (history page)
    property bool hoverHighlight: false
    //visual tuning per context
    property int cardRadius: States.tagRounding
    property int borderThick: States.borderOn ? 1 : 0

    //fired when the card body is clicked — each context decides what
    //acknowledging means there (popups untrack, history closes)
    signal bodyClicked()

    readonly property bool critical: notification?.urgency === NotificationUrgency.Critical

    Layout.fillWidth: true
    implicitHeight: content.implicitHeight + 20
    radius: card.cardRadius
    color: hoverHighlight && bodyHover.containsMouse ? Theme.recthovercolor : Theme.rectcolor

    border.width: card.critical ? 2 : card.borderThick
    border.color: card.critical ? Theme.alertcolor : Theme.bordercolor

    //critical notifications never auto-hide
    Timer {
        running: card.autoTimeout && card.notification !== null && card.notification.urgency !== NotificationUrgency.Critical
        interval: States.notifTimeout
        onTriggered: card.notification.tracked = false
    }

    MouseArea {
        id: bodyHover

        anchors.fill: parent
        hoverEnabled: card.hoverHighlight
        cursorShape: card.hoverHighlight ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            //the "default" action is the card body itself
            if (card.showActions && card.notification !== null) {
                const acts = card.notification.actions;
                for (let i = 0; i < acts.length; i++) {
                    if (acts[i].identifier === "default") {
                        acts[i].invoke();
                        break;
                    }
                }
            }
            card.bodyClicked();
        }
    }

    ColumnLayout {
        id: content

        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Image {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 36
                Layout.alignment: Qt.AlignTop
                fillMode: Image.PreserveAspectFit
                visible: source.toString() !== ""
                source: card.notification?.image || card.notification?.appIcon || ""
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        Layout.fillWidth: true
                        text: card.notification?.summary ?? ""
                        color: Theme.text1
                        elide: Text.ElideRight

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontlg
                            bold: true
                        }
                    }

                    Text {
                        visible: card.timeLabel !== ""
                        text: card.timeLabel
                        color: Theme.textmuted

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontmd
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    visible: text !== ""
                    text: card.notification?.body ?? ""
                    color: Theme.text1
                    wrapMode: Text.WordWrap

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontmd
                    }
                }

                Text {
                    visible: text !== ""
                    text: card.notification?.appName ?? ""
                    color: Theme.textmuted

                    font {
                        family: Theme.fontfamily
                        pixelSize: Theme.fontsm
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            visible: card.showActions && actionsRepeater.count > 0
            spacing: 6

            Repeater {
                id: actionsRepeater

                //the "default" action is the card body click, not a button
                model: {
                    const acts = card.notification?.actions ?? [];
                    const out = [];
                    for (let i = 0; i < acts.length; i++) {
                        if (acts[i].identifier !== "default")
                            out.push(acts[i]);
                    }
                    return out;
                }

                delegate: Rectangle {
                    required property var modelData

                    implicitHeight: 28
                    implicitWidth: actionTxt.implicitWidth + 18
                    radius: States.sliderRounding
                    color: actionHover.containsMouse ? Theme.recthovercolor : Theme.occupiedcolor

                    border {
                        width: States.borderOn ? 1 : 0
                        color: Theme.bordercolor
                    }

                    Text {
                        id: actionTxt

                        anchors.centerIn: parent
                        text: modelData.text
                        color: Theme.text1

                        font {
                            family: Theme.fontfamily
                            pixelSize: Theme.fontsm
                        }
                    }

                    MouseArea {
                        id: actionHover

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            const target = card.notification;
                            modelData.invoke();
                            if (target !== null)
                                target.tracked = false;
                        }
                    }
                }
            }
        }
    }
}
