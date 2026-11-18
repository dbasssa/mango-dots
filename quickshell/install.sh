#!/usr/bin/env bash
# Quickshell config for MangoWM on Arch-based systems.
#
# Installs the runtime dependencies and creates the files the shell expects
# (state, wallpaper folders, MangoWM window rule, pywal hook). Safe to re-run.
#
# Usage:
#   ./install.sh                  install packages and create missing files
#   ./install.sh --skip-packages  only create/verify files
#   ./install.sh --with-optional  also install optional audio/network/bt tools
#   ./install.sh --install-config copy this checkout to ~/.config/quickshell
#   ./install.sh --check          report status, change nothing

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET_DIR="$CONFIG_HOME/quickshell"
MANGO_DIR="$CONFIG_HOME/mango"
MANGO_CONF="$MANGO_DIR/config.conf"
MANGO_TOML="$MANGO_DIR/config.toml"

# filled in by detect_mango_config():
#   MANGO_KIND        "conf", "toml", or "" when no config exists
#   MANGO_CONFIG_FILE the file MangoWM will actually load
MANGO_KIND=""
MANGO_CONFIG_FILE=""

SKIP_PACKAGES=0
WITH_OPTIONAL=0
INSTALL_CONFIG=0
CHECK_ONLY=0

for arg in "$@"; do
    case "$arg" in
        --skip-packages) SKIP_PACKAGES=1 ;;
        --with-optional) WITH_OPTIONAL=1 ;;
        --install-config) INSTALL_CONFIG=1 ;;
        --check) CHECK_ONLY=1 ;;
        -h|--help)
            awk 'NR == 1 { next } /^#/ { sub(/^# ?/, ""); print; next } { exit }' "$0"
            exit 0
            ;;
        *)
            printf 'unknown option: %s\n' "$arg" >&2
            exit 2
            ;;
    esac
done

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }
as_root() {
    if ((EUID == 0)); then
        "$@"
    else
        sudo "$@"
    fi
}

# MangoWM loads ~/.config/mango/config.conf when it exists and only falls back
# to config.toml otherwise (see src/config/load.c). Mirror that precedence so
# the installer edits the file the compositor actually reads.
detect_mango_config() {
    MANGO_KIND=""
    MANGO_CONFIG_FILE=""

    if [[ -f "$MANGO_CONF" ]]; then
        MANGO_KIND="conf"
        MANGO_CONFIG_FILE="$MANGO_CONF"
        if [[ -f "$MANGO_TOML" ]]; then
            warn "Both config.conf and config.toml exist; MangoWM loads config.conf."
            warn "Edits will go to $MANGO_CONF and config.toml will be ignored."
        fi
    elif [[ -f "$MANGO_TOML" ]]; then
        MANGO_KIND="toml"
        MANGO_CONFIG_FILE="$MANGO_TOML"
    fi
}

# Packages shipped in the Arch repositories.
REPO_PKGS=(
    quickshell
    qt6-declarative
    cliphist
    wl-clipboard
    ddcutil
    brightnessctl
    ttf-meslo-nerd
)

# Packages that only exist in the AUR.
AUR_PKGS=(
    mangowm-git
    python-pywal16-git
)

# Session tools the widgets use when present. They normally come with the
# desktop stack, so they are only installed on request.
OPTIONAL_PKGS=(
    grim
    slurp
    libpulse
    wireplumber
    networkmanager
    bluez-utils
    upower
)

# Theme folders declared in modules/themeing/ThemeState.qml. Created up front
# so the wallpaper model never points at a missing directory; themes without
# images are blocked by the shell at runtime.
THEME_FOLDERS=(
    dark
    light
    gruvbox-dark
    gruvbox-light
    everforest
    everforest-light
    nord
    nord-light
    tokyo-night
    tokyo-night-light
    kanagawa
    rose-pine
    catppuccin-mocha
    pink
)

install_packages() {
    local missing=()
    local pkg

    if ! have pacman; then
        warn "pacman not found; this config targets Arch-based systems."
        warn "Install the packages manually: ${REPO_PKGS[*]} ${AUR_PKGS[*]}"
        return 0
    fi

    for pkg in "${REPO_PKGS[@]}"; do
        pacman -Qq "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
    done

    if ((${#missing[@]})); then
        say "Installing repo packages: ${missing[*]}"
        as_root pacman -S --needed --noconfirm "${missing[@]}"
    else
        say "Repo packages already installed."
    fi

    local aur_missing=()
    for pkg in "${AUR_PKGS[@]}"; do
        pacman -Qq "$pkg" >/dev/null 2>&1 || aur_missing+=("$pkg")
    done

    if ((${#aur_missing[@]})); then
        local helper
        helper="$(command -v paru || command -v yay || true)"
        if [[ -n "$helper" ]]; then
            say "Installing AUR packages: ${aur_missing[*]}"
            "$helper" -S --needed --noconfirm "${aur_missing[@]}"
        else
            warn "AUR packages missing and no paru/yay found: ${aur_missing[*]}"
            warn "Install them manually — mangowm-git provides mango and mmsg,"
            warn "python-pywal16-git provides wal."
        fi
    fi

    if ((WITH_OPTIONAL)); then
        local opt_missing=()
        for pkg in "${OPTIONAL_PKGS[@]}"; do
            pacman -Qq "$pkg" >/dev/null 2>&1 || opt_missing+=("$pkg")
        done
        if ((${#opt_missing[@]})); then
            say "Installing optional packages: ${opt_missing[*]}"
            as_root pacman -S --needed --noconfirm "${opt_missing[@]}"
        fi
    fi
}

copy_config() {
    if [[ "$SCRIPT_DIR" == "$TARGET_DIR" ]]; then
        return 0
    fi

    say "Copying config to $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
    if have rsync; then
        rsync -a --exclude '.git' --exclude 'state/' "$SCRIPT_DIR/" "$TARGET_DIR/"
    else
        (cd "$SCRIPT_DIR" && tar --exclude=.git --exclude=state -cf - .) \
            | (cd "$TARGET_DIR" && tar -xf -)
    fi
    SCRIPT_DIR="$TARGET_DIR"
}

ensure_state() {
    mkdir -p "$SCRIPT_DIR/state" "$SCRIPT_DIR/walls"

    if [[ ! -f "$SCRIPT_DIR/state/state.json" ]]; then
        printf '{}\n' > "$SCRIPT_DIR/state/state.json"
        say "Created $SCRIPT_DIR/state/state.json"
    fi

    local folder
    for folder in "${THEME_FOLDERS[@]}"; do
        [[ -d "$SCRIPT_DIR/walls/$folder" ]] || mkdir -p "$SCRIPT_DIR/walls/$folder"
    done
}

ensure_pam() {
    local f="$SCRIPT_DIR/pam/password.conf"
    if [[ -f "$f" ]]; then
        return 0
    fi
    mkdir -p "$SCRIPT_DIR/pam"
    printf 'auth required pam_unix.so\n' > "$f"
    say "Created $f"
}

write_mango_wal() {
    local f="$1"

    cat > "$f" <<'EOF'
#!/bin/bash
# Translate pywal's colors into MangoWM's border colors.
# Generated by the quickshell install script; re-running install.sh regenerates
# this file, so keep custom logic in a separate script.
#
# MangoWM prefers config.conf over config.toml, so the active file is detected
# at runtime. Both formats use the same color key names.

set -euo pipefail

[[ -r ~/.cache/wal/colors ]] || exit 0

mapfile -t walcolors <~/.cache/wal/colors

to_mango() {
  echo "0x${1:1:6}ff"
}

keys=(root_color border_color focus_color urgent_color drop_color split_color \
      maximized_screen_color scratchpad_color global_color overlay_color)

declare -A colors=(
  [root_color]="$(to_mango "${walcolors[0]}")"
  [border_color]="$(to_mango "${walcolors[0]}")"
  [focus_color]="$(to_mango "${walcolors[1]}")"
  [urgent_color]="$(to_mango "${walcolors[9]}")"
  [drop_color]="$(to_mango "${walcolors[1]}")"
  [split_color]="$(to_mango "${walcolors[2]}")"
  [maximized_screen_color]="$(to_mango "${walcolors[3]}")"
  [scratchpad_color]="$(to_mango "${walcolors[4]}")"
  [global_color]="$(to_mango "${walcolors[5]}")"
  [overlay_color]="$(to_mango "${walcolors[6]}")"
)

if [[ -f "$HOME/.config/mango/config.conf" ]]; then
  conf="$HOME/.config/mango/config.conf"
  for key in "${keys[@]}"; do
    value="${colors[$key]}"
    if grep -q "^${key}=" "$conf"; then
      sed -i "s|^${key}=.*|${key}=${value}|" "$conf"
    else
      printf '%s=%s\n' "$key" "$value" >> "$conf"
    fi
  done
else
  toml="$HOME/.config/mango/bordercolor.toml"
  : > "$toml"
  for key in "${keys[@]}"; do
    printf '%s = %s\n' "$key" "${colors[$key]}" >> "$toml"
  done
fi

if command -v mmsg >/dev/null 2>&1; then
  mmsg dispatch reload_config >/dev/null 2>&1 || true
fi
EOF
    chmod +x "$f"
}

ensure_mango_wal() {
    local f="$MANGO_DIR/mango-wal.sh"
    mkdir -p "$MANGO_DIR"

    if [[ ! -f "$f" ]]; then
        write_mango_wal "$f"
        say "Created $f"
        return 0
    fi

    # Only touch files that came from this installer. A hand-written hook
    # without the header is left alone so local changes are not clobbered.
    if grep -Fq 'Generated by the quickshell install script' "$f" \
        || grep -Fq 'cat >~/.config/mango/bordercolor.toml' "$f"; then
        write_mango_wal "$f"
        say "Updated $f"
    else
        say "Left custom $f untouched."
    fi
}

ensure_mango_rule() {
    if [[ -z "$MANGO_KIND" ]]; then
        warn "No MangoWM config found (config.conf or config.toml) — skipping the Settings window rule."
        return 0
    fi

    local f="$MANGO_CONFIG_FILE"

    if [[ "$MANGO_KIND" == "toml" ]]; then
        if grep -Fq 'title = "^Settings$"' "$f"; then
            local tmp
            tmp="$(mktemp)"
            # Rewrite width/height/is_floating inside the Settings rule block
            # only, so a rule left over from an older install is refreshed.
            awk '
                function flush() {
                    if (inblock && settings) {
                        if (!seen_w) print "width = 1200"
                        if (!seen_h) print "height = 800"
                    }
                }
                /^\[\[rule\.window_rule\]\]/ {
                    flush()
                    inblock = 1; settings = 0; seen_w = 0; seen_h = 0
                    print; next
                }
                inblock && /^[[:space:]]*title[[:space:]]*=/ {
                    if ($0 ~ /\^Settings\$/) settings = 1
                    print; next
                }
                inblock && settings && /^[[:space:]]*is_floating[[:space:]]*=/ {
                    print "is_floating = 1"; next
                }
                inblock && settings && /^[[:space:]]*width[[:space:]]*=/ {
                    print "width = 1200"; seen_w = 1; next
                }
                inblock && settings && /^[[:space:]]*height[[:space:]]*=/ {
                    print "height = 800"; seen_h = 1; next
                }
                { print }
                END { flush() }
            ' "$f" > "$tmp" && mv "$tmp" "$f"
            say "Updated the Settings window rule in $f"
            return 0
        fi

        cat >> "$f" <<'EOF'

# quickshell's Settings window is a regular xdg-toplevel; float it instead of
# letting the tiling layout swallow it
[[rule.window_rule]]
app_id = "org.quickshell"
title = "^Settings$"
is_floating = 1
width = 1200
height = 800
EOF
    else
        if grep -Fq 'title:^Settings$' "$f"; then
            sed -i 's@^window_rule=.*title:\^Settings\$.*$@window_rule=is_floating:1,app_id:org.quickshell,title:^Settings$,width:1200,height:800@' "$f"
            say "Updated the Settings window rule in $f"
            return 0
        fi

        cat >> "$f" <<'EOF'

# quickshell's Settings window is a regular xdg-toplevel; float it instead of
# letting the tiling layout swallow it
window_rule=is_floating:1,app_id:org.quickshell,title:^Settings$,width:1200,height:800
EOF
    fi

    say "Added the Settings window rule to $f"
}

ensure_mango_keybind() {
    if [[ -z "$MANGO_KIND" ]]; then
        warn "No MangoWM config found (config.conf or config.toml) — skipping the screenshot keybind."
        return 0
    fi

    if [[ "$MANGO_KIND" == "conf" ]]; then
        local f="$MANGO_CONFIG_FILE"

        if grep -Fq 'screenshot-qs region' "$f"; then
            sed -i -E 's@^(bind=[^,]*, *[^,]*, *spawn,).*screenshot-qs region.*$@\1qs ipc call screenshot-qs region@' "$f"
            say "Updated the screenshot keybind in $f"
            return 0
        fi

        printf '\n# region screenshot (grim + slurp)\n%s\n' \
            'bind=NONE,Print,spawn,qs ipc call screenshot-qs region' >> "$f"
        say "Added the screenshot keybind to $f"
        return 0
    fi

    local f="$MANGO_DIR/binds.toml"
    local bind='Print = "spawn,qs ipc call screenshot-qs region"'

    if [[ ! -f "$f" ]]; then
        warn "No $f found — skipping the screenshot keybind (install MangoWM, then re-run)."
        return 0
    fi

    if grep -Fq 'screenshot-qs region' "$f"; then
        sed -i -E 's@^([^=]+=)[[:space:]]*.*screenshot-qs region.*$@\1 "spawn,qs ipc call screenshot-qs region"@' "$f"
        say "Updated the screenshot keybind in $f"
        return 0
    fi

    if ! grep -Eq '^\[bind\.default\]' "$f"; then
        warn "$f has no [bind.default] table — add this bind manually:"
        warn "  $bind"
        return 0
    fi

    #insert inside the existing table; appending a second [bind.default]
    #header would make the file invalid TOML
    local tmp
    tmp="$(mktemp)"
    awk -v bind="$bind" '
        { print }
        /^\[bind\.default\]/ && !done {
            print "# region screenshot (grim + slurp)"
            print bind
            done = 1
        }
    ' "$f" > "$tmp" && mv "$tmp" "$f"
    say "Added the screenshot keybind to $f"
}

report() {
    local missing=()
    local cmd

    for cmd in mango mmsg wal cliphist wl-copy wl-paste systemctl; do
        have "$cmd" || missing+=("$cmd")
    done

    if ((${#missing[@]})); then
        warn "Missing required commands: ${missing[*]}"
    else
        say "Required commands present."
    fi

    if [[ -n "$MANGO_KIND" ]]; then
        say "MangoWM config: $MANGO_CONFIG_FILE ($MANGO_KIND)"
    else
        warn "No MangoWM config found under $MANGO_DIR (config.conf or config.toml)."
        warn "The Settings window rule, screenshot keybind and pywal hook cannot be added."
    fi

    if have brightnessctl && brightnessctl --class=backlight -m >/dev/null 2>&1; then
        say "Brightness backend: brightnessctl (internal panel)."
    elif have ddcutil; then
        if ddcutil detect --brief 2>/dev/null | grep -q '/dev/i2c-'; then
            say "Brightness backend: ddcutil (external DDC/CI monitor)."
        else
            warn "ddcutil is installed but no DDC/CI display was detected."
            warn "The brightness slider will be disabled at runtime."
        fi
    else
        warn "No brightness backend found (brightnessctl or ddcutil)."
        warn "The brightness slider will be disabled at runtime."
    fi

    for cmd in pactl wpctl nmcli bluetoothctl upower grim slurp; do
        have "$cmd" || warn "$cmd not found — the matching widget will be unavailable."
    done

    if [[ ! -f "$SCRIPT_DIR/state/state.json" ]]; then
        warn "state/state.json is missing."
    fi
    if [[ ! -f "$SCRIPT_DIR/pam/password.conf" ]]; then
        warn "pam/password.conf is missing — unlocking will not work."
    fi
}

say "Quickshell config: $SCRIPT_DIR"
detect_mango_config

if ((CHECK_ONLY)); then
    report
    exit 0
fi

if ((INSTALL_CONFIG)); then
    copy_config
fi

if ((SKIP_PACKAGES == 0)); then
    install_packages
fi

ensure_state
ensure_pam
ensure_mango_wal
ensure_mango_rule
ensure_mango_keybind
report

say "Done. Quickshell reloads on file changes; restart it with: qs -c $SCRIPT_DIR"
