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

Commit #(i lost count) Changes:
- Revamped Notifications (which now has its own menu, with IPC) and created a Lock Screen (called with IPC, bindable)
    ```
    # calls for control center 
    qs ipc call ctrlcntr-qs toggle
    # call for settings app
    qs ipc call settings-qs toggle
    # call for notifications menu
    qs ipc call notifications-qs toggle
    # call for lock screen
    qs ipc call lockscreen-qs toggle
    ```
- Added a "Fun" setting in the last rectangle of the settings app. this will be staying there
- Removed notification count from Control Center Button in full and island mode


**TODO:**
- Adding more functionality to the settings app (ability to change gaps, Bar length and height, and some other features)
- Add more features to the Bar itself (suggestions welcome)
- Change the way the Control center button looks in Full and Island Bar mode. (Smaller and more minimal)
- figure out a way to have changes in settings persist
