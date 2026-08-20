pragma Singleton
import QtQuick

QtObject {
    property string bgcolor: ThemeState.bgcolor
    property string rectcolor: ThemeState.rectcolor
    property string recthovercolor: ThemeState.recthovercolor

    property string occupiedcolor: ThemeState.occupiedcolor
    property string emptycolor: ThemeState.emptycolor
    property string pilltextcolor: ThemeState.pilltextcolor

    property string bordercolor: ThemeState.bordercolor
    property string wsbordercolor: ThemeState.wsbordercolor

    property string text1: ThemeState.text1
    property string textmuted: ThemeState.textmuted
    property string textactive: ThemeState.textactive

    property string alertcolor: ThemeState.alertcolor
    property string miconcolor: ThemeState.miconcolor

    property string fontfamily: "GohuFont 11 Nerd Font Propo"
    property int fontxs: 10
    property int fontsm: 11
    property int fontmd: 12
    property int fontbase: 13
    property int fontlg: 14
    property int fontxl: 16
    property int fontxxl: 20
}
