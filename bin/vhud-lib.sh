#!/usr/bin/env bash
# Shared helpers for the Valorant dev HUD scripts.
OS="$(uname -s)"
VHUD_HOME="${VHUD_HOME:-$HOME/.config/vhud}"
VHUD_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/vhud"
mkdir -p "$VHUD_CACHE"
# shellcheck disable=SC1091
[ -f "$VHUD_HOME/config" ] && . "$VHUD_HOME/config"

# Palette (truecolor escapes)
C_RED=$'\e[38;2;255;70;85m'; C_WHITE=$'\e[38;2;236;232;225m'; C_DIM=$'\e[38;2;118;128;121m'
C_TEAL=$'\e[38;2;23;222;166m'; C_BG=$'\e[48;2;31;35;38m'; C_RST=$'\e[0m'

# cache_fresh FILE MINUTES -> success if file younger than MINUTES
cache_fresh() { [ -f "$1" ] && [ -n "$(find "$1" -mmin -"$2" 2>/dev/null)" ]; }

# Directory of the most recently active shell (written by shell/vhud.sh), else $PWD
vhud_cwd() {
  local f="$VHUD_CACHE/cwd-${ZELLIJ_SESSION_NAME:-default}"
  if [ -s "$f" ] && [ -d "$(cat "$f")" ]; then cat "$f"; else pwd; fi
}
