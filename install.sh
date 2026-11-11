#!/usr/bin/env bash
# Valorant HUD installer for Ghostty + Zellij
# Supports macOS (Darwin) and Linux.
set -euo pipefail

DOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
ARCH="$(uname -m)"

RED='\033[38;2;255;70;85m'
WHITE='\033[38;2;236;232;225m'
DIM='\033[38;2;118;128;121m'
RST='\033[0m'

msg()  { printf "${RED}◢${RST} ${WHITE}%s${RST}\n" "$*"; }
sub()  { printf "  ${DIM}%s${RST}\n" "$*"; }
warn() { printf "${RED}WARNING:${RST} %s\n" "$*"; }

echo -e "${RED}"
cat <<'BANNER'
 __     __     _      ___  ____     _    _   _ _____   _   _ _   _ ____
 \ \   / /_   / \    / _ \|  _ \   / \  | \ | |_   _| | | | | | | |  _ \
  \ \ / / _` / _ \  | | | | |_) | / _ \ |  \| | | |   | |_| | | | | | | |
   \ V / (_|/ ___ \ | |_| |  _ < / ___ \| |\  | | |   |  _  | |_| | |_| |
    \_/ \__,_/_/   \_\\___/|_| \_\_/   \_|_| \_| |_|   |_| |_|\___/|____/
BANNER
printf "${RST}\n"
msg "Installing Valorant Dev HUD for Ghostty & Zellij"
sub "Target OS: $OS ($ARCH)"

# 1. Zellij & zjstatus
ZELLIJ_VERSION="0.45.1"
ZJSTATUS_VERSION="0.25.0"

INSTALL_BIN="$HOME/.local/bin"
PLUGINS_DIR="$HOME/.local/share/zellij/plugins"
mkdir -p "$INSTALL_BIN" "$PLUGINS_DIR"

if ! command -v zellij >/dev/null 2>&1 || [ "${1:-}" = "--force" ]; then
  msg "Installing Zellij $ZELLIJ_VERSION to $INSTALL_BIN..."
  case "$OS" in
    Darwin)
      if command -v brew >/dev/null 2>&1; then
        brew install zellij
      else
        TAR="zellij-${ARCH}-apple-darwin.tar.gz"
        curl -sL "https://github.com/zellij-org/zellij/releases/download/v${ZELLIJ_VERSION}/${TAR}" | tar xz -C "$INSTALL_BIN"
      fi
      ;;
    Linux)
      TAR="zellij-x86_64-unknown-linux-musl.tar.gz"
      [ "$ARCH" = "aarch64" ] && TAR="zellij-aarch64-unknown-linux-musl.tar.gz"
      curl -sL "https://github.com/zellij-org/zellij/releases/download/v${ZELLIJ_VERSION}/${TAR}" | tar xz -C "$INSTALL_BIN"
      ;;
  esac
else
  sub "Zellij is already installed: $(zellij --version)"
fi

if [ ! -f "$PLUGINS_DIR/zjstatus.wasm" ] || [ "${1:-}" = "--force" ]; then
  msg "Downloading zjstatus $ZJSTATUS_VERSION..."
  curl -sL -o "$PLUGINS_DIR/zjstatus.wasm" \
    "https://github.com/dj95/zjstatus/releases/download/v${ZJSTATUS_VERSION}/zjstatus.wasm"
else
  sub "zjstatus.wasm is already present"
fi

# 2. Config dirs
GHOSTTY_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
ZELLIJ_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zellij"
VHUD_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/vhud"
mkdir -p "$GHOSTTY_CONFIG_DIR/themes" "$ZELLIJ_CONFIG_DIR/layouts" "$ZELLIJ_CONFIG_DIR/themes" "$VHUD_CONFIG_DIR"

backup() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local ts; ts="$(date +%Y%m%d%H%M%S)"
    msg "Backing up existing $target -> ${target}.${ts}.bak"
    mv "$target" "${target}.${ts}.bak"
  fi
}

# 3. Symlink theme & configs
msg "Symlinking configurations..."
backup "$GHOSTTY_CONFIG_DIR/themes/valorant"
ln -sf "$DOT_DIR/ghostty/themes/valorant" "$GHOSTTY_CONFIG_DIR/themes/valorant"

backup "$GHOSTTY_CONFIG_DIR/config"
ln -sf "$DOT_DIR/ghostty/config" "$GHOSTTY_CONFIG_DIR/config"

backup "$ZELLIJ_CONFIG_DIR/themes/valorant.kdl"
ln -sf "$DOT_DIR/zellij/themes/valorant.kdl" "$ZELLIJ_CONFIG_DIR/themes/valorant.kdl"

backup "$ZELLIJ_CONFIG_DIR/layouts/valorant.kdl"
ln -sf "$DOT_DIR/zellij/layouts/valorant.kdl" "$ZELLIJ_CONFIG_DIR/layouts/valorant.kdl"

backup "$ZELLIJ_CONFIG_DIR/config.kdl"
ln -sf "$DOT_DIR/zellij/config.kdl" "$ZELLIJ_CONFIG_DIR/config.kdl"

# Default weapon loadout and vhud config
if [ ! -f "$VHUD_CONFIG_DIR/weapons.conf" ]; then
  cp "$DOT_DIR/config/weapons.conf" "$VHUD_CONFIG_DIR/weapons.conf"
  sub "Created $VHUD_CONFIG_DIR/weapons.conf (customize your loadout here)"
fi
if [ ! -f "$VHUD_CONFIG_DIR/config" ]; then
  cp "$DOT_DIR/config/vhud.example" "$VHUD_CONFIG_DIR/config"
  sub "Created $VHUD_CONFIG_DIR/config (set city, Jira, Bitbucket here)"
fi

# 4. Binaries to ~/.local/bin
msg "Installing vhud-* scripts to $INSTALL_BIN..."
for b in "$DOT_DIR"/bin/vhud-*; do
  ln -sf "$b" "$INSTALL_BIN/$(basename "$b")"
done

# 5. Shell hook reminder
msg "Verifying PATH and shell hook..."
SHELL_RC="$HOME/.zshrc"
[ ! -f "$SHELL_RC" ] && SHELL_RC="$HOME/.bashrc"
HOOK_LINE="source \"$DOT_DIR/shell/vhud.sh\""
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

if ! grep -qs 'vhud.sh' "$SHELL_RC" 2>/dev/null; then
  echo "" >> "$SHELL_RC"
  echo "# Valorant HUD directory tracking hook" >> "$SHELL_RC"
  echo "$HOOK_LINE" >> "$SHELL_RC"
  sub "Added hook to $SHELL_RC"
fi

case ":$PATH:" in
  *":$INSTALL_BIN:"*) ;;
  *)
    if ! grep -qs '\.local/bin' "$SHELL_RC" 2>/dev/null; then
      echo "$PATH_LINE" >> "$SHELL_RC"
      sub "Added $INSTALL_BIN to PATH in $SHELL_RC"
    fi
    ;;
esac

echo ""
msg "INSTALL COMPLETE"
echo -e "${WHITE}Next steps:${RST}"
echo -e "  1. Reload your shell: ${DIM}source $SHELL_RC${RST}"
echo -e "  2. Ensure you have JetBrains Mono Nerd Font installed: ${DIM}https://www.nerdfonts.com/${RST}"
echo -e "  3. Open Ghostty -- it will boot fullscreen into the Valorant HUD."
echo -e "  4. Weapons: ${RED}Alt+1..9${RST} to equip slots, ${RED}Alt+B${RST} for Buy Menu, ${RED}Alt+F${RST} to toggle floating HUD."
echo ""
