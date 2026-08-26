Hello! This repo is mainly meant as a way for me to keep my system the same if i have to reset for some reason. 

as of now, my config consists of mango, kitty, and quickshell config. if you decide to add these to your own files, then everything goes into the your /home/USER/.config directory.

That being said, feel free to take parts of the config or files and add them to your own configs, I do not care, just make sure you have the respective programs installed. 

This project is partially vibe coded for the animations and more complicated parts of the config. I am by no means a programmer, so please dont expect this to be perfect or efficient either. I personally dont run the greatest of specs, and it seems to work fine for me. If theres any problems, heres what I run for reference:

**My Hardware**
- R5 3500X
- Nvidia GeForce 1660Ti
- 16GB DDR4 @ 3200MHz

I run CachyOS, but any arch-based distro or arch itself should be fine (i have not and will not be testing this, it is purely speculation)

**Required programs/packages**

- mangowm (wayland window manager)
- Quickshell (Desktop shell for wayland)
- kitty (terminal emulator)
- zen-browser (browser)
- swaylock (lockscreen for wayland)
- yazi (TUI file manager)
- ~/walls/THEMENAME (directory for wallpapers under themes)

**Updates:**

v0.01 Changes:
- Removed Workspaces from quickshell (personal preference, since i dont use more than one workspace. 
- Updated the App Launcher to make it more efficient and smaller size.
- Updated the Settings App to include "Notch" style instead of Pill. Island and Full Bar remain untouched
- Added IPC tools to spawn Settings and Control Center which can be bound in the config (needed with Notch Bar style, optional with others)
    ```
    # calls for each menu 
    qs ipc call ctrlcntr-qs toggle
    qs ipc call settings-qs toggle
    ```
- Added Screen Frame Settings to the Settings App, adjusting thickness and rounding, as well as toggling it on/off is now doable through the Settings app

**TODO:**
- Adding more functionality to the settings app (ability to change gaps, Bar length and height, and some other features)
- Add more features to the Bar itself (suggestions welcome)
- Revamp Notifications and the notification center (visible in the control center)
- Change the way the Control center button looks in Full and Island Bar mode. (Smaller and more minimal)
