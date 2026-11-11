# Valorant Developer HUD - Visual & Architecture Design

This document details how the Riot Games Valorant UI design language (from [interfaceingame.com/games/valorant](https://interfaceingame.com/games/valorant/)) is mapped into a daily-driver developer environment using Ghostty and Zellij.

---

## 1. Palette Translation

Valorant's signature look pairs deep tactical navy with aggressive red accents, stark off-white text, and muted cyan/teal data points:

| Token | Hex | Terminal Role | In-Game Source |
|---|---|---|---|
| **Navy Base** | `#0F1923` | Ghostty background | Main menu / In-game canvas |
| **Panel Surface**| `#1F2326` | Floating pane background | Buy menu item cards / Settings |
| **Riot Red** | `#FF4655` | Accent, cursor, borders, active tab | Brand mark, hit markers, HUD borders |
| **Valorant White**| `#ECE8E1` | Foreground text, headers | In-game HUD fonts, timer, kill feed |
| **Dim Gray** | `#768079` | Inactive tabs, separators, labels | Sub-captions, weapon stats labels |
| **Teal / Cyan** | `#17DEA6` | Ping, success, git clean | Radianite, friendly health bars |
| **Spike Yellow** | `#F0B232` | Warnings, branch dirty | Spike indicator, warning toasts |

Ghostty applies this palette across 16 ANSI colors, with real window blur and 88% opacity.

---

## 2. Layout Geometry

```
+-------------------------------------------------------------------------------+
| ◢ Tue 11 Nov  │ PING 12MS │ CPU 14% │ +55°F Clear │ ⎇ main ✓ │ PROJ-42 ◣  D E V  ◥ 1 DEV  2 LOGS ◥ |  <- zjstatus
+-------------------------------------------------------------------------------+
| +-[ VITALS ]--+ |                                           | +-[ GIT ]-----+ |
| | NET PING 12 | |                                           | | ⎇ main ✓    | |
| | CPU 14%     | |                                           | | 3 files     | |
| | RAM 38%     | |              CENTER SHELL                 | +-------------+ |
| | WX  +55°F   | |             (CROSSHAIR CLI)               | +-[ TICKETS ]-+ |
| | UP  3h 12m  | |                                           | | PROJ-42 INPR| |
| +-------------+ |                                           | | PROJ-40 CODE| |
|                 |                                           | +-------------+ |
+-------------------------------------------------------------------------------+
| ───────────────────────────────────────────────────────────────────────────── |
| ▌1 GIT   ▌2 TTT   ▌3 DOCKER   ▌4 JIRA   ▌5 PRS   ▌6 POSTING   ▌7 VSCODE       |  <- Weapon Bar
|                       ALT+1-9 EQUIP   ALT+B BUY MENU   ALT+F TOGGLE HUD       |
+-------------------------------------------------------------------------------+
```

### Components
1. **Top Bar (Top Chrome / Buy Phase Timer bar)**
   - Left: real-time telemetry (datetime, ping, CPU/RAM/battery, weather, git branch, Jira ticket).
   - Center: `◢ D E V ◣` branding mimicking Valorant's round / match point indicator.
   - Right: numbered tabs with red active highlight.
2. **Main Shell (Crosshair)**
   - Centered and uninterrupted.
   - Flanked by borderless invisible gutter panes so floating panels sit on the margins rather than covering code.
3. **Floating HUD Panels (Tactical Cards)**
   - Framed with Valorant clipped corners (`◢ ─── ◥` and `◣ ─── ◢`).
   - `VITALS` (left): network, resource usage, weather, host, uptime.
   - `LOADOUT // GIT` (top right): branch, dirty files, ahead/behind upstream, recent commits.
   - `MISSION // TICKETS` (bottom right): active Jira ticket and open Bitbucket PRs.
   - Press **`Alt+F`** at any time to toggle all floating HUD panels on or off.
4. **Weapon Bar (Arsenal / Loadout)**
   - Sits along the bottom edge like the in-game weapon/ability selector.
   - Quick-equip slots 1 through 9 via **`Alt+1`** through **`Alt+9`**.
5. **Arsenal "Buy Menu" (`Alt+B`)**
   - Centered modal powered by `fzf` styled in the red/teal palette.
   - Fuzzy-search and equip any dev tool, including secondary weapons (Chrome, Firefox).

---

## 3. Weapons Loadout Mapping

| Slot | Tool | Kind | Purpose in Dev Stack |
|---|---|---|---|
| **1** | `git` / `lazygit` | TUI | Primary rifle: source control |
| **2** | `ttt` | TUI | Sidearm: quick text editor ([tttedit.dev](https://tttedit.dev/)) |
| **3** | `docker` / `lazydocker` | TUI | Heavy: container orchestration |
| **4** | `jira` | TUI | Intel: team issue tracker |
| **5** | `prs` (Bitbucket) | TUI | Intel: pull request review |
| **6** | `posting` | TUI | Utility: API client ([posting.sh](https://posting.sh/)) |
| **7** | `vscode` | GUI | Full IDE weapon |
| **8** | `cursor` | GUI | AI-assisted IDE |
| **9** | `antigravity` | GUI | AI agent companion |
| **-** | `chrome` / `firefox` | GUI | Browsers (Arsenal Buy Menu only) |

Customizable in `~/.config/vhud/weapons.conf`.
