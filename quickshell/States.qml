pragma Singleton
import QtQuick

QtObject {
    id: root

    // App launcher open/closed
    property bool appOpen: false

    // Control center open/closed
    property bool ctrlOpen: false

    // Theme picker overlay open/closed
    property bool themePickerOpen: false

    // Wallpaper picker overlay open/closed
    property bool wallPickerOpen: false

    //Settings App opener
    property bool settingsOpen: false

    //Notification center opener
    property bool notifOpen: false

    //lock screen toggle
    property bool lockScreen: false

    //System Monitor toggle
    property bool statsOpen: false


    property bool funTime: false





    //Appearance Settings (changeable in Settings app)

    //Bar dimensions when in pill/island mode (bound)
    property int barHeight: 40
    property int barWidth: 200
    //Bars Available Types (Bound)
    property bool fullBar: true
    property bool islandBar: false
    property bool notchBar: false
    //toggles the screen frame along the edges of the monitor (Bound)
    property bool frameVis: true
    property int frameThickness:5
    property int frameRounding: 5
    //outer gap inside bar (Bound)
    property int barMargin: 12
    //Gap from top of screen to top of notch (Bound)
    property int notchMargin: 5
    //Bar Rounding (Bound)
    property int barRounding: 20
    
    //notification Card timer & Margin
    property int notifCardSideMargin: 10
    property int notifTimeout: 5000


}
