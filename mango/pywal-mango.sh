#!/bin/bash
# Apply pywal colors to mango WM borders and reload
# Run after: wal -i <wallpaper> -q

CACHE="$HOME/.cache/wal/colors.json"
CONF="$HOME/.config/mango/config.conf"

[ -f "$CACHE" ] || exit 1

c() { jq -r ".colors.color$1" "$CACHE"; }

bg=$(c 0 | tr -d '#')
fg=$(c 7 | tr -d '#')
ac=$(c 4 | tr -d '#')
urgent=$(c 1 | tr -d '#')
dim=$(c 8 | tr -d '#')

sed -i \
  -e "s/^rootcolor=.*/rootcolor=0x${bg}ff/" \
  -e "s/^bordercolor=.*/bordercolor=0x${dim}ff/" \
  -e "s/^focuscolor=.*/focuscolor=0x${ac}ff/" \
  -e "s/^urgentcolor=.*/urgentcolor=0x${urgent}ff/" \
  "$CONF"

mmsg -d reload_config 2>/dev/null

# Update Zen browser theme via pywalfox
pywalfox update 2>/dev/null
