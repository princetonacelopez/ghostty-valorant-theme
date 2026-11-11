# Ghostty Valorant Dev HUD

A full-screen developer workflow for [Ghostty](https://ghostty.org/) and [Zellij](https://zellij.dev/), styled after the tactical HUD and visual design of **Riot Games' VALORANT** (reference: [interfaceingame.com/games/valorant](https://interfaceingame.com/games/valorant/)).

```
 ◢ Tue 11 Nov 18:50  │  PING 12MS  │  CPU 14%  RAM 38%  │  +55°F Clear  │  ⎇ main ✓  │  PROJ-42 ◣      ◢ D E V ◣      1 DEV  2 LOGS ◥ 
 ┌ VITALS ───── 0/1 | PIN [+] ┐│                                                               │  ┌ GIT ─────── SCROLL:  0/1 | PIN [+] ┐
 │◢ VITALS ━━━━━━━━━━━━━━━━━━◥││                                                               │  │◢ LOADOUT // GIT ━━━━━━━━━━━━━━━━━━◥│
 │ NET    PING 12MS           ││                                                               │  │ BRANCH main                        │
 │ CPU    14%                 ││                                                               │  │ DIRTY  0 files                     │
 │ RAM    38%                 ││                         MAIN SHELL                            │  │ SYNC   behind 0 / ahead 0          │
 │ WX     +55°F Clear         ││                      (CROSSHAIR CLI)                          │  │ f4aa161 Initial commit             │
 │ HOST   macbook             ││                                                               │  │◣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
 │ UP     3h 12m              ││                                                               │  └────────────────────────────────────┘
 │◣━━━━━━━━━━━━━━━━━━━━━━━━━━ ││                                                               │
 └────────────────────────────┘│                                                               │
───────────────────────────────┴───────────────────────────────────────────────────────────────┴────────────────────────────────────────
▌1 GIT  ▌2 TTT  ▌3 DOCKER  ▌4 JIRA  ▌5 PRS  ▌6 POSTING  ▌7 VSCODE  ▌8 CURSOR  ▌9 ANTIGRAVITY
                        ALT+1-9 EQUIP   ALT+B BUY MENU   ALT+F TOGGLE HUD
```

---

## Features

- **Full-Screen Tactical Immersion:** Boots Ghostty borderless and fullscreen with glassy 88% opacity and 20px blur.
- **Official Valorant Palette:** Navy (`#0F1923`), Riot Red (`#FF4655`), Off-white (`#ECE8E1`), and Radianite Teal (`#17DEA6`).
- **Valorant Top Bar (`zjstatus`):**
  - **Left:** System vitals (date/time, real-time ping, CPU, RAM, battery, weather, git branch & dirty state, active Jira ticket).
  - **Center:** `◢ D E V ◣` branding.
  - **Right:** Numbered tabs with red active highlight.
- **Crosshair Main Shell:** Centered terminal flanked by dedicated margins so HUD cards never obscure your shell.
- **Floating HUD Modals:**
  - `VITALS` (left): network, resource usage, weather, uptime.
  - `LOADOUT // GIT` (top right): branch, dirty files, sync status, recent commits.
  - `MISSION // TICKETS` (bottom right): current Jira ticket and open Bitbucket PRs.
  - Press `Alt+F` anytime to toggle all floating panels on/off.
- **Weapon Loadout Bar:** Dev tools mapped to slots 1–9 along the bottom edge. Press `Alt+1`..`Alt+9` to equip.
- **Arsenal Buy Menu (`Alt+B`):** Fuzzy picker (`fzf`) styled in Valorant colors to equip any tool or launch secondary apps (Chrome, Firefox).
- **Cross-Platform:** Works on **macOS** and **Linux** with automatic OS detection and keyless/offline fallbacks.

---

## Installation

### Prerequisites
- [Ghostty](https://ghostty.org/) terminal
- A Nerd Font installed (e.g. [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads))
- `fzf`, `jq`, `curl`

### Quick Install

```bash
git clone https://github.com/princetonacelopez/ghostty-valorant-theme.git ~/.config/ghostty-valorant-theme
cd ~/.config/ghostty-valorant-theme
./install.sh
```

The installer will:
1. Install [Zellij](https://zellij.dev/) `v0.45.1` and the [zjstatus](https://github.com/dj95/zjstatus) `v0.25.0` plugin into `~/.local/`.
2. Back up any existing configs and symlink the Valorant themes and layouts.
3. Install `vhud-*` helper tools into `~/.local/bin`.
4. Add the directory-tracking shell hook to `~/.zshrc` (or `~/.bashrc`).

---

## Keybindings (Default)

| Shortcut | Action |
|---|---|
| `Alt + 1` .. `9` | **Equip Weapon** (launches slot 1-9 as a floating tool or app) |
| `Alt + B` | **Arsenal Buy Menu** (search & equip any tool with fuzzy finder) |
| `Alt + F` | **Toggle HUD** (hide/show all floating HUD panes) |
| `Alt + [` / `]` | Switch tabs |
| `Alt + N` | New tab |

---

## Weapons Loadout (`~/.config/vhud/weapons.conf`)

Default slots:

```
1 | GIT         (lazygit / git status)
2 | TTT         (tttedit.dev)
3 | DOCKER      (lazydocker / docker ps)
4 | JIRA        (jira tickets list)
5 | PRS         (bitbucket pull requests)
6 | POSTING     (posting.sh API client)
7 | VSCODE      (open -a "Visual Studio Code" / code)
8 | CURSOR      (open -a Cursor / cursor)
9 | ANTIGRAVITY (open -a Antigravity)
- | CHROME      (Buy menu only)
- | FIREFOX     (Buy menu only)
```

Edit `~/.config/vhud/weapons.conf` to customize your weapons, hotkeys, and commands.

---

## Integrations (`~/.config/vhud/config`)

Sensitive tokens are read strictly from environment variables and **never stored in the repo**:

### Weather
Set your city in `~/.config/vhud/config`:
```bash
VHUD_CITY="San Francisco"
```
Leave empty to auto-detect your location via IP.

### Jira
Export these in your shell environment (e.g., via 1Password CLI, pass, or your secrets manager):
```bash
export JIRA_BASE_URL="https://yourcompany.atlassian.net"
export JIRA_EMAIL="developer@example.com"
export JIRA_API_TOKEN="your-api-token"
```
The HUD automatically extracts the Jira ticket key (e.g. `PROJ-1234`) from your current git branch and queries its status.

### Bitbucket
```bash
export BITBUCKET_USER="your-bitbucket-username"
export BITBUCKET_TOKEN="your-app-password"
```
Shows the top 5 open pull requests for the current git remote repository.

---

## Architecture & Visual Details

See [`docs/design.md`](docs/design.md) for full color specifications, ASCII mockups, and architectural details.

## License

MIT
