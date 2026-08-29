Hello! Welcome to the Official Repository for Shell-Yeah (until i move the quickshell directory into a different repo, that is).

Shell-Yeah is a Quickshell based Desktop shell built for mangowm. However, it should work on any other Wayland compositor with no issues (I have not tested this, so take it with a grain of salt). 

Supported Operating Systems are those supported by both mangowm and quickshell. 

Shell-Yeah handles a lot of different things, including Wallpaper & Wallpaper switching, Theme & Theme switching, Notifications, Bar Appearance, System Monitoring, Launching Apps, & System Controls, it is possible that some programs you may have installed (eg. Mako, awww, & others) may interfere with Shell-Yeah, so if there are any issues with installing and using the shell, please disable or close those programs, including possibly removing them from your autostart.

This Shell is still a work in progress, and is currently being worked on/added to. If you experience any issues with the Shell or installation, please raise an issue, and i will do my best to fix it as soon as possible.

If you would like to Download and use Shell-Yeah, here's the **install steps**:
- Install mangowm for your OS using [these](https://mangowm.github.io/docs/installation) instructions
- Install Quickshell for your OS using [these](https://quickshell.org/docs/v0.3.0/guide/install-setup/) instructions
- Create a directory using ```mkdir -p /home/$USER/walls/{dark/,light/,catppuccin-mocha/,gruvbox-dark/,nord/,pink/,tokyo-night/}``` for your wallpapers
- Copy and sort all of your wallpapers
- **That concludes the set up**
- Clone this repo into ```~/.config/``` or ```/home/$USER/.config/```
- launch Quickshell using ```qs```. if that doesnt work, use ```qs -p /home/$USER/quickshell/shell.qml``` instead
- Once the bar (and possibly other elements) of the shell load, Shell-Yeah is ready to be used. Enjoy!

**Recommended Steps to get the most out of Shell-Yeah**
- in your mango config, bind the IPC commands for each call
    ```
    # call for control center 
    qs ipc call ctrlcntr-qs toggle
    # call for settings app
    qs ipc call settings-qs toggle
    # call for notifications menu
    qs ipc call notifications-qs toggle
    # call for lock screen
    qs ipc call lockscreen-qs toggle
    #call for system monitor
    qs ipc call systemmonitor-qs toggle
    ```

**Required programs/packages**

- [```mangowm```](https://mangowm.github.io/) (Window Manager)
- [quickshell](https://quickshell.org/) (Desktop Shell for wayland)
- ```/home/$USER/walls/THEME-NAME``` (directory for wallpapers under themes)

**Updates:**

Commit #(i lost count) Changes:

- Added a System Monitor triggered with Bindable IPC commands(RAM only, but CPU and GPU coming soon)
- Added more options to the settings app
- Changed the Volume icon in the control center to actual Volume %age.


**TODO:**
- Add a Button to toggle System Monitor visibility in the Bar
- Add CPU and GPU monitors to the System Monitor
- figure out a way to have changes in settings persist
