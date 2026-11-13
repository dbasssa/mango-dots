**Shell-Yeah**: A MangoWM shell written entirely in quickshell. (plus some JSON)

---
## **install steps**:
- install dependencies listed below
- clone this repo
- `cp -r mango-dots/quickshell ~/.config`
- `qs -p ~/.config/quickshell`
I am working on an install script, which will handle dependencies and folder placement automatically.
## **IPC Calls (Bound in mangowm)**
    # control center
    qs ipc call ctrlcntr-qs toggle
    # settings app
    qs ipc call settings-qs toggle
    # lock screen
    qs ipc call lockscreen-qs toggle
    # app launcher
    qs ipc call app-launcher toggle
    # clipboard manager
    qs ipc call clipboard-qs toggle
---
## **Required programs/packages**

- [`mangowm`](https://mangowm.github.io/) (Window Manager)
- [`quickshell`](https://quickshell.org/) (Desktop Shell for wayland)
- Google Sans Code NF (Font and Icons)
---
## Features 
- Fully themed Desktop & Status Bar Customization
- Wallpapers sorted by theme
- Notification handling via Quickshell
- Clipboard manager with history.
- Screenshot manager via grim + slurp
- Wifi and Bluetooth management via NetworkManager and BlueZ
- CPU and RAM monitoring
- Lock screen with information displays. 

---
### Note 
This shell is currently being worked on and hasnt reached a 1.0 state yet. That being said, all features (except one or two) will work completely. 
I also cannot guarantee that this shell will work on non-arch distros, since that is what i use to develop this shell (CachyOS & Arch).
I am 100% open to suggestions, feature ideas, and of course, bugs. if you find/want something, raise an issue and i will get to it as soon as i can.
