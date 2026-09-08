pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    Process {
        id:themeSaverProc
        command: [""]
        running: false
    }
    function saveTheme () {
        themeSaverProc.command = ["sh","-c","echo " + root.themeIndex + " > " + Quickshell.shellDir + "/state/theme"]
        themeSaverProc.running = true
    }
    Process {
        id: themeReaderProc
        command: ["sh","-c","cat " + Quickshell.shellDir + "/state/theme"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.themeIndex = parseInt(this.text)
        }
    }
    property int themeIndex: 0
    property var themes: [{
        name: "Dark",
        bgcolor: "#16161a",
        rectcolor: "#1e1e24",
        recthovercolor: "#24242c",
        occupiedcolor: "#3b3b44",
        bordercolor: "#2c2c34",
        text1: "#e6e6ea",
        textmuted: "#8a8a94",
        textactive: "#7aa2f7",
        alertcolor: "#f7768e",
        miconcolor: "#9ece6a",
        folder: "/dark"
    },
    {
        name: "Light",
        bgcolor: "#f0f0f5",
        rectcolor: "#e2e2ea", 
        recthovercolor: "#d4d4de",
        occupiedcolor: "#b4b4c0", 
        bordercolor: "#c0c0ca", 
        text1: "#1e1e24", 
        textmuted: "#6a6a78", 
        textactive: "#4a6ee0",
        alertcolor: "#d64550", 
        miconcolor: "#2a9040",
        folder: "/light"
        
    },
    {
        name: "Tokyo Night",
        bgcolor: "#1a1b26", 
        rectcolor: "#24283b", 
        recthovercolor: "#2f344a",
        occupiedcolor: "#414868", 
        bordercolor: "#3b4261", 
        text1: "#c0caf5", 
        textmuted: "#565f89", 
        textactive: "#7aa2f7",
        alertcolor: "#f7768e", 
        miconcolor: "#9ece6a",
        folder: "/tokyo-night"
    },
    {
        name: "Catppuccin Mocha",
        bgcolor: "#1e1e2e", 
        rectcolor: "#313244", 
        recthovercolor: "#45475a",
        occupiedcolor: "#585b70", 
        bordercolor: "#585b70", 
        text1: "#cdd6f4", 
        textmuted: "#6c7086", 
        textactive: "#89b4fa",
        alertcolor: "#f38ba8", 
        miconcolor: "#a6e3a1",
        folder: "/catppuccin-mocha"
    },
    {
        name: "Nord",
        bgcolor: "#2e3440", 
        rectcolor: "#3b4252", 
        recthovercolor: "#434c5e",
        occupiedcolor: "#4c566a", 
        bordercolor: "#4c566a", 
        text1: "#eceff4", 
        textmuted: "#7b88a1", 
        textactive: "#88c0d0",
        alertcolor: "#bf616a", 
        miconcolor: "#a3be8c",
        folder: "/nord"
    },
    {
        name: "Gruv Dark",
        bgcolor: "#282828", 
        rectcolor: "#3c3836", 
        recthovercolor: "#504945",
        occupiedcolor: "#665c54",
        bordercolor: "#665c54", 
        text1: "#ebdbb2", 
        textmuted: "#928374", 
        textactive: "#83a598",
        alertcolor: "#fb4934", 
        miconcolor: "#b8bb26",
        folder: "/gruvbox-dark"
    },
    {
        name: "Pink",
        bgcolor: "#fce4f0", 
        rectcolor: "#f0c8d8", 
        recthovercolor: "#e4b0c8",
        occupiedcolor: "#d498b4", 
        bordercolor: "#d498b4", 
        text1: "#2a1a28", 
        textmuted: "#8a6a7a", 
        textactive: "#c04070",
        alertcolor: "#d02050", 
        miconcolor: "#408040",
        folder: "/pink"
    }]
}
