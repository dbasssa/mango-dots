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
    property bool settingsOpen: true



    //Appearance Settings (changeable in Settings app)

    //Bar dimensions when in pill/island mode
    property int barHeight: 40
    property int barWidth: 200
    //Bars Available Types
    property bool fullBar: true
    property bool islandBar: false
    property bool notchBar: false
    //toggles the screen frame along the edges of the monitor
    property bool frameVis: true
    property int frameThickness:5
    property int frameRounding: 5
    //outer gap inside bar
    property int barMargin: 12


}
