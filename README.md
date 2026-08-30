Shell-Yeah: A Quickshell based shell made for mangowm...

This Shell is still a work in progress, and is currently being worked on/added to. If you experience any issues with the Shell or installation, please raise an issue.

If you would like to Download and use Shell-Yeah, here's the **install steps**:
- Create directory  ```mkdir -p /home/$USER/walls/{dark/,light/,catppuccin-mocha/,gruvbox-dark/,nord/,pink/,tokyo-night/}``` for wallpapers & sort them
- Clone this repo into ```/home/$USER/.config/```
- launch using ```qs``` or ```qs -p /home/$USER/.config/quickshell/shell.qml```
- Enjoy!
**IPC Calls**
    ```
    # call for control center 
    qs ipc call ctrlcntr-qs toggle
    # call for settings app
    qs ipc call settings-qs toggle
    # call for notifications menu
    qs ipc call notifications-qs toggle
    # call for lock screen
    qs ipc call lockscreen-qs toggle
    # call for system monitor
    qs ipc call systemmonitor-qs toggle
    ```

**Required programs/packages**

- [```mangowm```](https://mangowm.github.io/) (Window Manager)
- [```quickshell```](https://quickshell.org/) (Desktop Shell for wayland)

**Updates:**

Commit #(i lost count) Changes:

- Added a System Monitor triggered with Bindable IPC commands(RAM only, but CPU and GPU coming soon)
- Added more options to the settings app
- Changed the Volume icon in the control center to actual Volume %age.


**TODO:**
- Add a Button to toggle System Monitor visibility in the Bar
- Add CPU and GPU monitors to the System Monitor
- figure out a way to have changes in settings persist
