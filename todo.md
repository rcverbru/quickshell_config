# Quickshell build — status & plans

Goal: build a full custom Hyprland desktop shell in Quickshell, replacing Waybar. Building it piece by piece, starting with the bar, to learn the fundamentals along the way.

The engine itself lives at `/home/rcv/quickshell` (a clone of the upstream Quickshell repo) — this directory (`~/.config/quickshell/`) is the actual shell config it loads at runtime via bare `qs`/`quickshell`.

## Background — reference shells

Two shells are being used as references/sources to pull from:

- **hyprstar** — local clone at `/home/rcv/dev/sandbox/hyprstar/quickshell/`. Source of `theme/Theme.qml`, `Battery.qml`, the calendar/reminders/weather files (hyprstar's `modules/datetimepanel/*`, being renamed to `modules/dashboard/`), and most of `services/`. Uses `qs.` imports throughout.
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
- **Imports: `qs.` is the correct convention going forward.** Quickshell's own changelog (`~/quickshell/changelog/v0.2.0.md`) says `import qs.path.to.module` *replaces* `"root:/"` imports. Migration to `qs.` is done (see Done) — QML modules use `import qs.x.y`, JS files use paths relative to the importing file.
- Singletons don't need a `qmldir` — Quickshell's scanner (`src/core/scan.cpp`) detects `pragma Singleton` automatically. (hyprstar's `services/` has no qmldir and works; its `theme/qmldir` is redundant.)
- QML only registers files whose names start with a **capital letter** as types. Lowercase `.qml` files can't be referenced as types.
- `//@ pragma ...` lines only take effect in the root `shell.qml` — hyprstar's `Mask.qml` has one that does nothing.
- Toggleable popup/overlay pattern (used by `DesktopView`, `AppListView`): a `GlobalStates.qml` singleton boolean (e.g. `desktopViewOpen`) bound to a `PanelWindow.visible`, flipped via an `IpcHandler { target: "..." }`, invoked from a shell command as `qs ipc call <target> <function>`.
- `qs`/`quickshell` only renders correctly through the **nixGL** wrapper (`~/.local/bin/qs` routes through `nixGLIntel`) — the Nix-built binary can't see this laptop's real NVIDIA/Intel drivers otherwise. Don't rebuild against system Qt (apt's Qt is 6.4.2, this project requires 6.6+).

## Done

- **`qs.` import migration** — every `root:/` import converted (QML modules → `import qs.x.y`, JS files → relative paths from the importing file's folder); `top-bar` → `topbar`; `theme.qml` → `Theme.qml`; `.qmlls.ini` added (gitignored); `Wallpaper.qml` moved to `modules/background/` (not instantiated — it'd cover the current per-monitor wallpaper setup); `DockView.toggle()` bug fixed. Config is now a git repo.
- **`modules/topbar/TopBar.qml`** — minimal working bar, one `PanelWindow` per screen via `Variants`, live clock (`SystemClock`), `Battery` (hyprstar widget, first user of `Theme`) vertically centered on the left. To be converted into a plain `Item` for Drawers (see below).
- **`modules/desktopview/DesktopView.qml`** — "Show desktop" overlay, toggled via `qs ipc call desktopview toggle` (currently bound nowhere in Hyprland yet — `SUPER, A` still points at the old standalone `~/.config/quickshell/overview/` project via `OverviewToggle.sh`, needs repointing later). Full-screen `PanelWindow` per monitor, shows that monitor's own wallpaper (`~/.config/hypr/rofi/.current_wallpaper_<monitor-name>`, falling back to `Appearance.background_image`), contains an `AppList`.
- **`modules/common/AppList.qml`** — reusable app/window list box. Takes `required property HyprlandMonitor monitor` from its caller. Renders each toplevel in the monitor's active workspace as a row (`Rectangle` + `Text`, app name resolved via `DesktopEntries.heuristicLookup(appId)` with fallback to raw title), with a `MouseArea { hoverEnabled: true }` per row for hover reactions (in progress — see Next below).
- **`modules/applistview/AppListView.qml`** — standalone popup wrapper around `AppList`, for iterating on it in isolation without the full `DesktopView` overlay. `qs ipc call applist toggle`.
- **Removed `DockView`** — decided it wasn't needed; `modules/dockview/` and `GlobalStates.dockViewOpen` deleted.

## In progress

- Hover interaction on `AppList` rows — `MouseArea.hoverEnabled` is wired up, but no visual reaction or the "peek" preview behavior yet.
- Window thumbnails — `ScreencopyView` (native Quickshell type, `captureSource: modelData.wayland`) is stubbed out (commented) in `AppList.qml`'s row `Rectangle`, not yet re-enabled/styled.
- Rounded corners on the row boxes — `ClippingWrapperRectangle` (from `Quickshell.Widgets`) had a sizing bug we couldn't pin down (rendered at zero size); currently using a plain `Rectangle { clip: true; radius: ... }` instead, which works but doesn't clip a `ScreencopyView` child as cleanly as a dedicated clip container would.

## Next up — Drawers (caelestia-style window architecture)

**Decided:** one fullscreen, transparent, masked `PanelWindow` per screen (caelestia's `Drawers` pattern). Goal: hover dropdowns that grow out of the bar, a sidebar, rounded frame corners.

Current monitor layout (`hyprctl monitors`): `DP-6` x=0 (3440×1440) | `eDP-1` laptop x=3440 (2560×1600) | `DP-5` x=6000 (3440×1440).

**Structure — keep it component-per-file ("OOP" separation):**
- `modules/drawers/Drawers.qml` — the only file that owns the `Variants` + fullscreen `PanelWindow`. Anchored to all 4 edges, `color: "transparent"`, `WlrLayer.Top`, `ExclusionMode.Ignore`. Holds the `mask`, the `isLeftmost` logic, and wires components together.
- `modules/topbar/TopBar.qml` — becomes a plain `Item` (drop its `Scope`/`Variants`/`PanelWindow`); full width, `barHeight` tall.
- `modules/sidebar/SideBar.qml`, dropdowns, etc. — each a plain `Item` in its own module folder, instantiated inside `Drawers`.
- `modules/drawers/Exclusions.qml` — small invisible `PanelWindow`s whose only job is `exclusiveZone` (the overlay uses `ExclusionMode.Ignore`, so without these, tiled apps slide *under* the bar/sidebar). The sidebar's exclusion needs the same `isLeftmost` check.

**Key mechanics:**
- **Mask:** `mask: Region { Region { item: topBar }; Region { item: sideBar } }` — child regions combine; everything outside passes clicks through to apps. Open dropdowns must be in the mask too, or they won't take input.
- **Sidebar on the outermost edge (option 1 — chosen):** `readonly property bool isLeftmost: modelData.x === Math.min(...Quickshell.screens.map(s => s.x))`. Reactive to hotplug: docked → `DP-6`'s left edge; laptop-only → `eDP-1`. (Rejected: "each screen's non-touching edge" — `eDP-1` has neighbours on both sides; "follow focused monitor" — jumpy.)
- **Hover dropdowns across files:** `id`s don't cross files, so `TopBar` exposes state (e.g. `property string hoveredItem`) and `Drawers` binds siblings to it: `SomeDropdown { open: topBar.hoveredItem === "battery" }`. State lives per-window in `Drawers`, not in `GlobalStates` (each screen has its own dropdowns).

**Suggested order:**
1. Create `Drawers.qml` with the fullscreen masked window; convert `TopBar` to an `Item` inside it. Verify clicks still reach apps everywhere except the bar.
2. Add `SideBar` with `isLeftmost`.
3. Add `Exclusions.qml` so apps stop going under the bar/sidebar.
4. First hover dropdown (e.g. battery or the dashboard).
5. Rounded frame corners where bar and sidebar meet.

Target `shell.qml`:

```qml
import Quickshell
import qs.modules.drawers
import qs.modules.desktopview
import qs.modules.applistview

ShellRoot {
    Drawers {}       // bar + sidebar + dropdowns + exclusions, per screen
    DesktopView {}
    AppListView {}
}
```

(Add `//@ pragma UseQApplication` once there's a system tray.)

## Choices to make

- ~~**Window architecture**~~ — **decided: caelestia-style Drawers** (see Next up). Fullscreen overlays like `DesktopView` can stay as their own windows.
- **One theme system:** end-4's `Appearance` singleton (`modules/common/`) vs hyprstar's `Theme` singleton (`theme/`). Can coexist short-term, but eventually pick one so widgets aren't styled two ways. (caelestia has its own again, under its services/config.)
- **Where `Battery.qml` lives:** currently `modules/common/widgets/`; hyprstar keeps bar widgets in `modules/` and imports them as `qs.modules`. Decide on a home for bar widgets (e.g. `modules/topbar/widgets/`).
- **State model:** partly decided — bar dropdown state lives per-screen inside `Drawers`. `GlobalStates` stays for IPC-toggled overlays (`DesktopView`, etc.).
- **Whether Quickshell draws the wallpaper** (`modules/background/Wallpaper.qml`) or the current per-monitor rofi setup keeps doing it.
- **Retire Waybar** — still running above the Quickshell bar. Once Drawers + Exclusions work, remove it from Hyprland autostart.

## Needs review

- **`modules/datetimepanel/` → `modules/dashboard/`** (in progress — reorganizing) — renaming because "dashboard" better describes it. When the move lands, update `import qs.modules.datetimepanel` in `modules/common/WidgetPanel.qml` (and the path comments at the top of `Calendar.qml`/`Reminders.qml`). Holds `Calendar.qml`, `Reminders.qml`, `Weather.qml`, `Weather2.qml` — substantial files (100-560 lines each) from hyprstar, not wired in yet. Still being moved around. Good candidate for the first Drawers hover dropdown.
- `services/*` — copied in, not yet used or reviewed.

## Planned next (from the original desktop-view design discussion)

1. Re-enable `ScreencopyView` thumbnails per row (static capture by default).
2. Hover → swap to a bigger `live: true` `ScreencopyView` preview.
3. Click → `Hyprland.dispatch("focuswindow address:0x" + modelData.address)`, then close the overlay.
4. Repoint Hyprland's `SUPER, A` keybind (currently `system_keybinds.lua` → `OverviewToggle.sh` → the old standalone `overview` config) onto `DesktopView`'s IPC target — add the override in `UserKeybinds.conf`/`user_keybinds.lua`, not the system file.
5. Eventually: rounded corners on the top bar itself (Hyprland's `decoration.rounding` only affects real app windows, not Quickshell's own layer-shell surfaces — the bar needs its own QML-side rounding). Now handled by the Drawers plan (step 5).

## Known gotchas (learned the hard way)

- **A bad save mid-edit can wedge Quickshell's hot-reload** — if a reload error (`id is not unique`, `Type X unavailable`, etc.) doesn't clear after fixing the code and saving again, fully restart `qs` rather than keep chasing it.
- **`required property` only satisfies from the direct caller, and only once** — it needs to be set exactly where the component is instantiated from outside; setting it again inside the component's own file (reaching for an ambient `id` that isn't in scope there) throws `Cannot assign to non-existent property` or `was not initialized`.
- **`id`s don't cross file boundaries** — a component in its own `.qml` file can't see `id`s declared in whatever file instantiates it.
- **`Column` (and `Row`/`Grid`) forbid `fill`/`centerIn`/vertical anchors on their children** — they manage that axis themselves; use `anchors.left`/`right` only, or move the anchored item out of the layout container.
- **`Region` is not a visual container** — it's a geometry/masking descriptor for things like `PanelWindow.mask`, not a rounded-clip wrapper for arbitrary content.
- **`PanelWindow` has no `image` property** — need a child `Image { anchors.fill: parent }`, with the panel's own `color` set to `"transparent"`.
- **QML type files must be capitalized** — `theme.qml` is not a usable type; `Theme.qml` is.
- **`//@ pragma` only works in the root `shell.qml`.**
- **Read Quickshell error chains bottom-up** — the last `caused by` line is the real problem; everything above is fallout (one bad import in `Appearance` → `StyledText` → `TopBar` → whole shell fails).
- **Relative JS import paths start from the importing file's own folder** — `../` = up one level, no prefix = same folder. Files not loaded by `shell.qml` (e.g. `modules/overview/`) never report bad paths, so check them by hand.
- **Colors are strings** — `color: "transparent"`, not `color: transparent`. Unquoted, QML treats it as an undefined variable → `ReferenceError`, the binding silently fails, and the property keeps its default (a `PanelWindow` defaults to **white** — a fullscreen one whites out the screen). If a property seems to ignore what you wrote, check the log for `ReferenceError`.
- **Anchors are per-axis** — `verticalCenter` alone leaves `x` at 0 (flush left); combine with `anchors.left` + `leftMargin`. Only anchors on the *same* axis conflict.
