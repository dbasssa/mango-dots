**Shell-Yeah**: A Quickshell based shell made for mangowm...

This Shell is still a work in progress, and is currently being worked on/added to. If you experience any issues with the Shell or installation, please raise an issue.

---
# **install steps**:
- `mkdir -p ~/walls/{dark,light,catppuccin-mocha,gruvbox-dark,nord,pink,tokyo-night} # sorted wallpaper dir`
- Clone this repo into `~/.config/`
- `qs -p ~/.config/quickshell/shell.qml`
- Enjoy!
---
# **IPC Calls (Bound in mangowm)**

    # control center
    qs ipc call ctrlcntr-qs toggle
    # settings app
    qs ipc call settings-qs toggle
    # notifications menu
    qs ipc call notifications-qs toggle
    # lock screen
    qs ipc call lockscreen-qs toggle
    # system monitor
    qs ipc call systemmonitor-qs toggle
    # app launcher
    qs ipc call app-launcher toggle
---
# **Required programs/packages**

- [`mangowm`](https://mangowm.github.io/) (Window Manager)
- [`quickshell`](https://quickshell.org/) (Desktop Shell for wayland)
- Google Sans Code NF (Font and Icons)
---
# **Updates:**
- Added a CPU Monitor to the System Monitor
- Added a Workspaces module to show active workspace as well as occupied workspaces
- Added a focused window titlebar
- Changed some of the aesthetics of the bar


# **TODO:**
- Add a Button to toggle System Monitor visibility in the Bar
- Add GPU monitors to the System Monitor
- figure out a way to have changes in settings persist
- complete the install script to automate the setup and creation process
