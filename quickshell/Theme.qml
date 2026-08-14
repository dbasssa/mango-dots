pragma Singleton 
import QtQuick

QtObject {
    //panel and rectangle colors
    property string bgcolor:"#16161a"
    property string rectcolor: "#1e1e24"
    property string recthovercolor: "#24242c"

    //workspace/tag pill colors
    property string occupiedcolor: "#3b3b44"
    property string emptycolor: "#26262e"
    property string pilltextcolor: "#0e0e10"

    //border colors
    property string bordercolor: "#2c2c34"
    //workspace/tag border
    property string wsbordercolor: "#e6e6ea"


    //text colors
    property string text1:"#e6e6ea"
    property string textmuted: "#8a8a94"
    property string textactive: "#7aa2f7"

    //status / feedback colors
    property string alertcolor: "#f7768e"
    property string miconcolor: "#9ece6a"

    //fonts
    property string fontfamily: "GohuFont 11 Nerd Font Propo"
    property int fontxs: 10
    property int fontsm: 11
    property int fontmd: 12
    property int fontbase: 13
    property int fontlg: 14
    property int fontxl: 16
    property int fontxxl: 20

}