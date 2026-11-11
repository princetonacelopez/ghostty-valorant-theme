# Source from ~/.zshrc or ~/.bashrc. Records the active directory so the HUD can show git/ticket info.
_vhud_cwd() { mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/vhud"; printf '%s' "$PWD" > "${XDG_CACHE_HOME:-$HOME/.cache}/vhud/cwd-${ZELLIJ_SESSION_NAME:-default}"; }
if [ -n "$ZSH_VERSION" ]; then autoload -Uz add-zsh-hook; add-zsh-hook precmd _vhud_cwd
else PROMPT_COMMAND="_vhud_cwd${PROMPT_COMMAND:+;$PROMPT_COMMAND}"; fi
