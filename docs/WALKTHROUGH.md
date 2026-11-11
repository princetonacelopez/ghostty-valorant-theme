# Walkthrough: Valorant Developer HUD for Ghostty & Zellij

We have implemented a complete, installable developer environment styled after the tactical HUD and visual design language of **Riot Games' VALORANT** (referenced from [interfaceingame.com/games/valorant](https://interfaceingame.com/games/valorant/)).

---

## 1. Visual Design & Components Built

### Official Palette
- **Navy Base (`#0F1923`)**: Ghostty background + terminal background.
- **Surface / Cards (`#1F2326`)**: Floating HUD panel tinting.
- **Riot Red (`#FF4655`)**: Cursor, active tabs, panel headers, accent bars, borders.
- **Valorant White (`#ECE8E1`)**: Clean foreground text and data values.
- **Radianite Teal (`#17DEA6`)**: Ping, network status, clean git state.
- **Dim Gray (`#768079`)**: Muted labels and separators.

### Ghostty Configuration ([`ghostty/config`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/ghostty/config))
- **Fullscreen & Borderless:** `fullscreen = true`, `window-decoration = none`.
- **Glassmorphism:** `background-opacity = 0.88`, `background-blur = 20`.
- **Typography:** Uses JetBrains Mono Nerd Font with tuned cell heights and custom red block cursor.
- **Theme:** Native Ghostty color file [`ghostty/themes/valorant`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/ghostty/themes/valorant).
- **Auto-Boot:** `command = zellij --layout valorant`.

### First-Person HUD Layout ([`zellij/layouts/valorant.kdl`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/zellij/layouts/valorant.kdl))
- **Top Bar (`zjstatus` plugin):**
  - **Left:** Real-time telemetry (`date/time`, `PING`, `CPU/RAM/BAT`, `weather`, `git branch ±dirty`, `Jira ticket`).
  - **Center:** `◢ D E V ◣` branding mimicking Valorant's round / match point indicator.
  - **Right:** Numbered tabs with red active highlight.
- **Main Shell (Center "Crosshair"):** Unobstructed central terminal surrounded by invisible gutter panes so floating HUD panels rest on margins without obscuring your shell buffer.
- **Floating HUD Panels (Tactical Modals):**
  - `VITALS` (left): Ping, CPU, RAM, battery, weather, hostname, uptime.
  - `LOADOUT // GIT` (top right): Current branch, dirty files count, upstream sync, recent commits.
  - `MISSION // TICKETS` (bottom right): Active Jira ticket + open Bitbucket PRs.
  - Formatted with clipped corner markers (`◢ ─── ◥` / `◣ ─── ◢`).
  - **Toggle on/off at will** via **`Alt+F`**.
- **Bottom Weapon Bar:** Dev tools 1–9 mapped along the bottom edge, resembling the in-game weapon/ability bar.

---

## 2. Dev Weapons Loadout & Arsenal Buy Menu

Configured in [`config/weapons.conf`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/config/weapons.conf):

| Slot | Tool | Kind | Quick Key | Notes |
|---|---|---|---|---|
| **1** | `GIT` | TUI | `Alt+1` | `lazygit` (falls back to `git status`) |
| **2** | `TTT` | TUI | `Alt+2` | [tttedit.dev](https://tttedit.dev/) |
| **3** | `DOCKER` | TUI | `Alt+3` | `lazydocker` (falls back to `docker ps`) |
| **4** | `JIRA` | TUI | `Alt+4` | Team issue tracker |
| **5** | `PRS` | TUI | `Alt+5` | Bitbucket pull requests |
| **6** | `POSTING` | TUI | `Alt+6` | [posting.sh](https://posting.sh/) API client |
| **7** | `VSCODE` | GUI | `Alt+7` | VS Code (`open -a` on macOS, `code` on Linux) |
| **8** | `CURSOR` | GUI | `Alt+8` | Cursor IDE |
| **9** | `ANTIGRAVITY` | GUI | `Alt+9` | AI assistant |
| **-** | `CHROME` / `FIREFOX` | GUI | `Alt+B` | Available via Buy Menu |

### Arsenal "Buy Menu" (`Alt+B`)
Launches a centered modal running `fzf` styled in Valorant red, teal, and off-white to search and equip any tool on demand.

---

## 3. Portable Helper Scripts ([`bin/`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin))

- [`vhud-stats`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin/vhud-stats): CPU, RAM, and Battery with auto-detection for macOS (`sysctl`, `vm_stat`, `pmset`) and Linux (`/proc`, `free`, `/sys/class/power_supply`).
- [`vhud-ping`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin/vhud-ping): Valorant-style ping readout (`PING 12MS`), with TCP fallback when ICMP is blocked.
- [`vhud-weather`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin/vhud-weather): Weather via keyless `wttr.in`, cached for 15 minutes. Supports configured city or IP geolocation.
- [`vhud-git`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin/vhud-git): Tracks directory of the active shell session via precmd hook. Shows branch, dirty count, upstream sync, and commit log.
- [`vhud-jira`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin/vhud-jira): Extracts ticket keys (e.g. `ABC-123`) from branch names and queries Jira REST API.
- [`vhud-bitbucket`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin/vhud-bitbucket): Lists open PRs for the current git remote repository.
- [`vhud-weapons`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin/vhud-weapons): Renders the weapon loadout bar and equips slots.
- [`vhud-buy`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin/vhud-buy): Interactive fzf Arsenal modal.
- [`vhud-hud`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme/bin/vhud-hud): Continuous renderer for floating cards.

> [!NOTE]
> All credentials (`JIRA_*`, `BITBUCKET_*`) are read strictly from environment variables and never stored in files or repo commits.

---

## 4. Live Verification Output

A full live test of the entire layout running in an actual pseudo-terminal produced the following screen capture:

```text
 ┌ VITALS ───── 0/1 | PIN [+] ┐│                                                               │  ┌ GIT ─────── SCROLL:  0/1 | PIN [+] ┐
 │◢ VITALS ━━━━━━━━━━━━━━━━━━◥││                                                               │  │◢ LOADOUT // GIT ━━━━━━━━━━━━━━━━━━◥│
 │ NET    PING 0MS            ││                                                               │  │ BRANCH main                        │
 │ CPU    11%                 ││                                                               │  │ DIRTY  0 files                     │
 │ RAM    9%                  ││                                                               │  │ SYNC   behind 0 / ahead 0          │
 │ WX     +55°F Clear         ││                         MAIN SHELL                            │  │ f4aa161 Initial commit             │
 │ HOST   sandbox             ││                                                               │  │◣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
 │ UP     18 min              ││                                                               │  └────────────────────────────────────┘
 │◣━━━━━━━━━━━━━━━━━━━━━━━━━━ ││                                                               │
 └────────────────────────────┘│                                                               │  ┌ TICKETS ─── SCROLL:  0/1 | PIN [+] ┐
                               │                                                               │  │◢ MISSION // TICKETS ━━━━━━━━━━━━━━◥│
                               │                                                               │  │ TICKET NO TICKET                   │
                               │                                                               │  │ ╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌ │
                               │                                                               │  │ SET    JIRA_* env vars             │
                               │                                                               │  │ ╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌ │
                               │                                                               │  │ SET    BITBUCKET_* env vars        │
                               │                                                               │  │◣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
                               │                                                               │  └────────────────────────────────────┘
───────────────────────────────┴───────────────────────────────────────────────────────────────┴────────────────────────────────────────
▌1 GIT  ▌2 TTT  ▌3 DOCKER  ▌4 JIRA  ▌5 PRS  ▌6 POSTING  ▌7 VSCODE  ▌8 CURSOR  ▌9 ANTIGRAVITY
                        ALT+1-9 EQUIP   ALT+B BUY MENU   ALT+F TOGGLE HUD
```

---

## 5. Ready to Use

All files are committed to [`princetonacelopez/ghostty-valorant-theme`](file:///home/antigravity/princetonacelopez/ghostty-valorant-theme). On your machine:

```bash
git pull
./install.sh
```
Launch Ghostty to enter the Valorant HUD.
