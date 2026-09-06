pragma Singleton
import QtQuick

QtObject {
    property string bgcolor: ThemeState.themes[ThemeState.themeIndex].bgcolor
    property string rectcolor:  ThemeState.themes[ThemeState.themeIndex].rectcolor
    property string recthovercolor:  ThemeState.themes[ThemeState.themeIndex].recthovercolor
    property string occupiedcolor:  ThemeState.themes[ThemeState.themeIndex].occupiedcolor
    property string bordercolor:  ThemeState.themes[ThemeState.themeIndex].bordercolor
    property string text1:  ThemeState.themes[ThemeState.themeIndex].text1
    property string textmuted:  ThemeState.themes[ThemeState.themeIndex].textmuted
    property string textactive:  ThemeState.themes[ThemeState.themeIndex].textactive
    property string alertcolor:  ThemeState.themes[ThemeState.themeIndex].alertcolor
    property string miconcolor:  ThemeState.themes[ThemeState.themeIndex].miconcolor

    property string fontfamily: "Google Sans Code NF"
    property int fontxs: 10
    property int fontsm: 11
    property int fontmd: 12
    property int fontbase: 13
    property int fontlg: 14
    property int fontxl: 16
    property int fontxxl: 20
}
