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
        themeSaverProc.command = ["sh","-c","echo " + root.themeIndex + " > " + Quickshell.shellDir + "/state/theme"];
        themeSaverProc.running = true;
    }
    Process {
        id: themeReaderProc
        command: ["sh","-c","cat " + Quickshell.shellDir + "/state/theme"];
        running: true;
        stdout: StdioCollector {
            onStreamFinished: root.themeIndex = parseInt(this.text);
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
        name: "Gruv Light",
        bgcolor: "#fbf1c7",
        rectcolor: "#ebdbb2",
        recthovercolor: "#d5c4a1",
        occupiedcolor: "#bdae93",
        bordercolor: "#d5c4a1",
        text1: "#3c3836",
        textmuted: "#928374",
        textactive: "#076678",
        alertcolor: "#9d0006",
        miconcolor: "#79740e",
        folder: "/gruvbox-light"
    },
    {
        name: "Everforest",
        bgcolor: "#232a2e",
        rectcolor: "#2d353b",
        recthovercolor: "#343f44",
        occupiedcolor: "#475258",
        bordercolor: "#3d484d",
        text1: "#d3c6aa",
        textmuted: "#859289",
        textactive: "#7fbbb3",
        alertcolor: "#e67e80",
        miconcolor: "#a7c080",
        folder: "/everforest"
    },
    {
        name: "Everforest Light",
        bgcolor: "#fdf6e3",
        rectcolor: "#f4f0d9",
        recthovercolor: "#efebd4",
        occupiedcolor: "#e0dcc7",
        bordercolor: "#e6e2cc",
        text1: "#5c6a72",
        textmuted: "#939f91",
        textactive: "#3a94c5",
        alertcolor: "#f85552",
        miconcolor: "#8da101",
        folder: "/everforest-light"
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
        name: "Nord Light",
        bgcolor: "#eceff4",
        rectcolor: "#e5e9f0",
        recthovercolor: "#d8dee9",
        occupiedcolor: "#b7c2d4",
        bordercolor: "#d8dee9",
        text1: "#2e3440",
        textmuted: "#616e88",
        textactive: "#5e81ac",
        alertcolor: "#bf616a",
        miconcolor: "#a3be8c",
        folder: "/nord-light"
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
        name: "Tokyo Night Light",
        bgcolor: "#e1e2e7",
        rectcolor: "#d0d5e3",
        recthovercolor: "#c4c8da",
        occupiedcolor: "#a9b4d0",
        bordercolor: "#c4c8da",
        text1: "#3760bf",
        textmuted: "#848cb5",
        textactive: "#2e7de9",
        alertcolor: "#f52a65",
        miconcolor: "#587539",
        folder: "/tokyo-night-light"
    },
    {
        name: "Kanagawa",
        bgcolor: "#16161d",
        rectcolor: "#1f1f28",
        recthovercolor: "#2a2a37",
        occupiedcolor: "#363646",
        bordercolor: "#363646",
        text1: "#dcd7ba",
        textmuted: "#727169",
        textactive: "#7e9cd8",
        alertcolor: "#e82424",
        miconcolor: "#98bb6c",
        folder: "/kanagawa"
    },
    {
        name: "Rose Pine",
        bgcolor: "#191724",
        rectcolor: "#1f1d2e",
        recthovercolor: "#26233a",
        occupiedcolor: "#403d52",
        bordercolor: "#26233a",
        text1: "#e0def4",
        textmuted: "#6e6a86",
        textactive: "#c4a7e7",
        alertcolor: "#eb6f92",
        miconcolor: "#9ccfd8",
        folder: "/rose-pine"
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
