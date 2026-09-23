# Quickshell build — status & plans

Goal: build a full custom Hyprland desktop shell in Quickshell, replacing Waybar. Building it piece by piece, starting with the bar, to learn the fundamentals along the way.

The engine itself lives at `/home/rcv/quickshell` (a clone of the upstream Quickshell repo) — this directory (`~/.config/quickshell/`) is the actual shell config it loads at runtime via bare `qs`/`quickshell`.

## Background — reference shells

Two shells are being used as references/sources to pull from:

- **hyprstar** — local clone at `/home/rcv/dev/sandbox/hyprstar/quickshell/`. Source of `theme/Theme.qml`, `Battery.qml`, `modules/datetimepanel/*`, and most of `services/`. Uses `qs.` imports throughout.
- **caelestia shell** — `github.com/caelestia-dots/shell` (not cloned locally). Want to borrow its setup/architecture.

**Neither has a complicated `shell.qml`** — both keep it as a thin list of instances, same as the rule below:

- hyprstar's `shell.qml` only *looks* bigger because it writes the per-screen `Variants { model: Quickshell.screens ... }` loops inline (for `Wallpaper`, `Bar`, `Mask`). Ours puts the `Variants` inside the component (`TopBar`) instead — equivalent, arguably cleaner. Minus that, it's just `ThemeMenu`, `Wallpaper`, `Bar`, `Mask`, `Lockscreen`, `AppLauncher`. It also has `//@ pragma UseQApplication` at the top.
- caelestia's `shell.qml` is ~40 lines: `GSFLoader {}`, `ServiceLoader {}`, `Background {}`, `Drawers {}`, `AreaPicker {}`, `Lock { id: lock }`, `Shortcuts {}`, `BatteryMonitor {}`, `IdleMonitors { lock: lock }`. Its only extras are `//@ pragma Env ...` / `DefaultEnv` lines at the top and `settings.watchFiles: true`.

What actually gives each shell its *look* is window architecture, not the entry point:

- **caelestia `Drawers`** — one fullscreen, transparent `PanelWindow` per screen containing the bar, the screen-edge border, and every popout panel, with a `mask` region so only the visible parts take input. That's why panels appear to grow out of the frame — they're all in the same surface.
- **hyprstar `bar/Mask.qml`** — lighter version: a fullscreen bottom-layer gradient frame with a masked cut-out, plus a separate bar `PanelWindow`.
- **Ours (currently)** — a separate `PanelWindow`/`FloatingWindow` per feature, toggled via `GlobalStates` + IPC.

## Architecture notes

- `shell.qml` at the root is the thin entry point (`ShellRoot { TopBar {}; DesktopView {}; AppListView {} }`) — it should stay minimal, no feature logic. (Confirmed: both reference shells do the same.)
- Each feature lives in its own `modules/<name>/` folder as a plain component file (no per-module `shell.qml` — only the config root has one). `modules/common/` holds shared singletons (`Appearance`, `ConfigOptions`, `Directories`) and reusable widgets — this framework was borrowed from illogical-impulse (end-4/dots-hyprland) as a base, not written from scratch.
- `services/` holds singletons copied from hyprstar (`Bluetooth`, `Volume`, `Brightness`, `Mpris`, `Network`, …) plus a few end-4 extras (`AppSearch`, `ConfigLoader`, `HyprlandData`, `HyprlandKeybinds`, `MaterialThemeLoader`). Not wired in yet.
- **Imports: `qs.` is the correct convention going forward.** Quickshell's own changelog (`~/quickshell/changelog/v0.2.0.md`) says `import qs.path.to.module` *replaces* `"root:/"` imports. The older base code still uses `import "root:/modules/common"`; the hyprstar-sourced files (`Battery.qml`, `datetimepanel/*`) already use `import qs.theme as Theme` / `import qs.services as Services`. Migrate everything to `qs.` (see Migration below).
- Singletons don't need a `qmldir` — Quickshell's scanner (`src/core/scan.cpp`) detects `pragma Singleton` automatically. (hyprstar's `services/` has no qmldir and works; its `theme/qmldir` is redundant.)
- QML only registers files whose names start with a **capital letter** as types. Lowercase `.qml` files can't be referenced as types.
- `//@ pragma ...` lines only take effect in the root `shell.qml` — hyprstar's `Mask.qml` has one that does nothing.
- Toggleable popup/overlay pattern (used by `DesktopView`, `AppListView`, `DockView`): a `GlobalStates.qml` singleton boolean (e.g. `desktopViewOpen`) bound to a `PanelWindow.visible`, flipped via an `IpcHandler { target: "..." }`, invoked from a shell command as `qs ipc call <target> <function>`.
- `qs`/`quickshell` only renders correctly through the **nixGL** wrapper (`~/.local/bin/qs` routes through `nixGLIntel`) — the Nix-built binary can't see this laptop's real NVIDIA/Intel drivers otherwise. Don't rebuild against system Qt (apt's Qt is 6.4.2, this project requires 6.6+).

## Done

- **`modules/top-bar/TopBar.qml`** — minimal working bar, one `PanelWindow` per screen via `Variants`, live clock (`SystemClock`). Directory name has a hyphen (`top-bar`) — **must be renamed to `topbar`** as part of the `qs.` migration (hyphens aren't valid in `qs.` module paths).
- **`modules/desktopview/DesktopView.qml`** — "Show desktop" overlay, toggled via `qs ipc call desktopview toggle` (currently bound nowhere in Hyprland yet — `SUPER, A` still points at the old standalone `~/.config/quickshell/overview/` project via `OverviewToggle.sh`, needs repointing later). Full-screen `PanelWindow` per monitor, shows that monitor's own wallpaper (`~/.config/hypr/rofi/.current_wallpaper_<monitor-name>`, falling back to `Appearance.background_image`), contains an `AppList`.
- **`modules/common/AppList.qml`** — reusable app/window list box. Takes `required property HyprlandMonitor monitor` from its caller. Renders each toplevel in the monitor's active workspace as a row (`Rectangle` + `Text`, app name resolved via `DesktopEntries.heuristicLookup(appId)` with fallback to raw title), with a `MouseArea { hoverEnabled: true }` per row for hover reactions (in progress — see Next below).
- **`modules/applistview/AppListView.qml`** — standalone popup wrapper around `AppList`, for iterating on it in isolation without the full `DesktopView` overlay. `qs ipc call applist toggle`.
- **`modules/dockview/DockView.qml`** — scaffolded (`Scope` + `Variants` + `FloatingWindow` + `IpcHandler target: "dockview"`), but currently empty — no content inside the window yet, and has a known copy-paste bug (`toggle()` assigns to `GlobalStates.desktopViewOpen` instead of `GlobalStates.dockViewOpen`).

## In progress

- Hover interaction on `AppList` rows — `MouseArea.hoverEnabled` is wired up, but no visual reaction or the "peek" preview behavior yet.
- Window thumbnails — `ScreencopyView` (native Quickshell type, `captureSource: modelData.wayland`) is stubbed out (commented) in `AppList.qml`'s row `Rectangle`, not yet re-enabled/styled.
- Rounded corners on the row boxes — `ClippingWrapperRectangle` (from `Quickshell.Widgets`) had a sizing bug we couldn't pin down (rendered at zero size); currently using a plain `Rectangle { clip: true; radius: ... }` instead, which works but doesn't clip a `ScreencopyView` child as cleanly as a dedicated clip container would.

## Migration — `qs.` imports & wiring in hyprstar files (do first)

Mechanical cleanup so the base code and the hyprstar-sourced files work together:

1. Switch every `import "root:/modules/..."` to `import qs.modules...` (e.g. `import "root:/modules/common"` → `import qs.modules.common`). Includes `shell.qml`, `GlobalStates.qml`, `services/AppSearch.qml`, `HyprlandKeybinds.qml`, `MaterialThemeLoader.qml`, and the modules.
2. Rename `modules/top-bar/` → `modules/topbar/`.
3. Rename `theme/theme.qml` → `theme/Theme.qml` — `Battery`, `Calendar`, `Reminders`, `Weather` reference `Theme.Theme.xxx` (27 uses), which requires a type named `Theme`; they can't resolve until it's capitalized.
4. Add an empty `.qmlls.ini` in the config root — Quickshell auto-populates it so QMLLS understands `qs.` imports and singletons (system-dependent; don't commit it).
5. Drop the unused `import "root:/modules/common/"` from `GlobalStates.qml`.
6. `services/Wallpaper.qml` is **not a service** — it's a per-screen window (hyprstar instantiates it via `Variants` in `shell.qml`). Move it to something like `modules/background/` (depends on `qs.theme`).
7. Add `//@ pragma UseQApplication` to `shell.qml` when needed (required for e.g. system tray menus).
8. Fix `DockView.toggle()` bug.

Target `shell.qml` after migration:

```qml
//@ pragma UseQApplication
import Quickshell
import qs.modules.topbar
import qs.modules.background
import qs.modules.desktopview
import qs.modules.applistview
import qs.modules.dockview

ShellRoot {
    Background {}    // wallpaper / frame, per-screen Variants inside
    TopBar {}        // later maybe "Drawers"
    DesktopView {}
    AppListView {}
    DockView {}
}
```

## Choices to make

- **Window architecture (the big one — decide before building many bar popouts):**
  - *Keep separate windows per feature* (current) — simplest, fine for learning and for fullscreen overlays like `DesktopView`.
  - *caelestia-style `Drawers`* — `TopBar` evolves into one fullscreen masked `PanelWindow` per screen that holds the bar + border + all popouts. Needed for panels that slide out of the bar / rounded screen-frame corners. Changes where every popout lives, so choose early.
  - *hyprstar-style* — separate bar window + a bottom-layer `Mask` frame. Middle ground.
- **One theme system:** end-4's `Appearance` singleton (`modules/common/`) vs hyprstar's `Theme` singleton (`theme/`). Can coexist short-term, but eventually pick one so widgets aren't styled two ways. (caelestia has its own again, under its services/config.)
- **Where `Battery.qml` lives:** currently `modules/common/widgets/`; hyprstar keeps bar widgets in `modules/` and imports them as `qs.modules`. Decide on a home for bar widgets (e.g. `modules/topbar/widgets/`).
- **State model:** keep global `GlobalStates` booleans, or move to caelestia-style per-screen visibility state (matters once there are multiple monitors with independent popouts).

## Needs review

- `modules/common/widgets/Battery.qml`, `modules/datetimepanel/Calendar.qml`, `Reminders.qml`, `Weather.qml`, `theme/theme.qml` — substantial files (100-560 lines each) from hyprstar, **not wired into `shell.qml`** yet. Import-convention question is resolved (use `qs.`) — blocked only on the Migration steps above, then wire `Battery` + the date/time panel into the bar.
- `services/*` — copied in, not yet used or reviewed.

## Planned next (from the original desktop-view design discussion)

1. Re-enable `ScreencopyView` thumbnails per row (static capture by default).
2. Hover → swap to a bigger `live: true` `ScreencopyView` preview.
3. Click → `Hyprland.dispatch("focuswindow address:0x" + modelData.address)`, then close the overlay.
4. Repoint Hyprland's `SUPER, A` keybind (currently `system_keybinds.lua` → `OverviewToggle.sh` → the old standalone `overview` config) onto `DesktopView`'s IPC target — add the override in `UserKeybinds.conf`/`user_keybinds.lua`, not the system file.
5. Decide what goes in `DockView` and fix the `toggle()` bug.
6. Eventually: rounded corners on the top bar itself (Hyprland's `decoration.rounding` only affects real app windows, not Quickshell's own layer-shell surfaces — the bar needs its own QML-side rounding). Ties into the window-architecture choice above.

## Known gotchas (learned the hard way)

- **A bad save mid-edit can wedge Quickshell's hot-reload** — if a reload error (`id is not unique`, `Type X unavailable`, etc.) doesn't clear after fixing the code and saving again, fully restart `qs` rather than keep chasing it.
- **`required property` only satisfies from the direct caller, and only once** — it needs to be set exactly where the component is instantiated from outside; setting it again inside the component's own file (reaching for an ambient `id` that isn't in scope there) throws `Cannot assign to non-existent property` or `was not initialized`.
- **`id`s don't cross file boundaries** — a component in its own `.qml` file can't see `id`s declared in whatever file instantiates it.
- **`Column` (and `Row`/`Grid`) forbid `fill`/`centerIn`/vertical anchors on their children** — they manage that axis themselves; use `anchors.left`/`right` only, or move the anchored item out of the layout container.
- **`Region` is not a visual container** — it's a geometry/masking descriptor for things like `PanelWindow.mask`, not a rounded-clip wrapper for arbitrary content.
- **`PanelWindow` has no `image` property** — need a child `Image { anchors.fill: parent }`, with the panel's own `color` set to `"transparent"`.
- **QML type files must be capitalized** — `theme.qml` is not a usable type; `Theme.qml` is.
- **`//@ pragma` only works in the root `shell.qml`.**
