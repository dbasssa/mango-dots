**Shell-Yeah**: A Quickshell based shell made for mangowm... WE'RE BACK AND BETTER (sort of...)

This Shell is still a work in progress, and is currently being worked on/added to. If you experience any issues with the Shell or installation, or just have a feature request, please raise an issue.

---
## **install steps**:
- Clone this repo into `~/.config/`
- `qs -p ~/.config/quickshell/shell.qml`
- Enjoy!
---
## **IPC Calls (Bound in mangowm)**

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
## **Required programs/packages**

- [`mangowm`](https://mangowm.github.io/) (Window Manager)
- [`quickshell`](https://quickshell.org/) (Desktop Shell for wayland)
- Google Sans Code NF (Font and Icons)
---
## **Updates:**
- Removed Theme and Wallpaper switcher due to a file search error on some devices.
- Localized the walls directory. all wallpapers must be stored in `~/.config/quickshell/walls/`
- Added a Battery and network monitor to the control center button.
- Redid the control center and some other menus/functions
- Optimized aand reworked a bunch of different problems with the whole shell


## **TODO:**
- Add a Button to toggle System Monitor visibility in the Bar
- Add GPU monitors to the System Monitor
- figure out a way to have changes in settings persist
- complete the install script to automate the setup and creation process
- feel godly and love life again
