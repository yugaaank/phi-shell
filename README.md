<div align="center">

# phi-shell

[![Quickshell](https://img.shields.io/badge/Quickshell-QtQuick%20Wayland-41CD52?logo=qt&logoColor=white)](https://quickshell.org)
[![QML](https://img.shields.io/badge/UI-QML%2FQtQuick-41B883?logo=qt&logoColor=white)](#architecture)
[![License](https://img.shields.io/badge/license-MIT-8b5cf6)](#license)

</div>

`phi-shell` is a desktop shell written in QML for [Quickshell](https://quickshell.org)
— a Wayland shell toolkit built on QtQuick. Rather than stitching together a
separate bar, dock, launcher, and settings app, `phi-shell` defines them as
modules in one process, driven by a single JSON config.

## Why

A desktop shell is really one cohesive surface. `phi-shell` keeps the bar,
dock, desktop, popups, and settings as modules of the same `ShellRoot`, so
theming, layout, and widget wiring live in one place instead of in several
unsynchronized tools.

## Architecture

`shell.qml` declares the root and mounts the modules:

```qml
ShellRoot {
    Desktop {} TopBar {} Dock {} AppLauncher {}
    SettingsApp {} Dashboard {} Sidebar {}
}
```

```
phi-shell/
├── shell.qml           # entry: ShellRoot + module mounts
├── core/               # Colors.qml, Config.qml, GlobalStates.qml, qmldir
├── modules/
│   ├── bar/  TopBar.qml
│   ├── dock/ Dock.qml
│   ├── desktop/        # Desktop + AppLauncher
│   ├── popups/         # transient surfaces
│   └── settings/       # SettingsApp + SettingRow* (toggle/slider/dropdown/text)
├── services/           # AudioService, BatteryService, ClockService (qmldir)
├── components/         # ActiveWindowWidget, WorkspacesWidget, ClockWidget,
│                       # AudioWidget, BatteryWidget, StyledRect
├── config.json         # layout + appearance + widgets
├── colors.json apps.json
└── scripts/            # extract_colors.sh, generate_colors.py,
                        # update_apps.sh, update_config.sh
```

- **Services** — `AudioService`/`BatteryService`/`ClockService` expose live
  state (volume, charge, time) that widgets bind to.
- **Widgets** — composable QML components placed into the bar via
  `config.json` (`barLeft` / `barCenter` / `barRight`).
- **Theming** — `colors.json` + `config.json` (`theme`, `borderRadius`,
  `fontFamily`, `wallpaperPath`) drive the look; `scripts/generate_colors.py`
  and `extract_colors.sh` regenerate palettes.

## Configuration

`config.json` controls layout (`barMode`, `barMargin`, `dockIconSize`),
appearance (`theme`, `borderRadius`, `fontFamily`, `wallpaperPath`), and which
widgets sit in each bar zone. `apps.json` feeds the launcher.

## Getting started

Requires Quickshell (QtQuick + Wayland).

```bash
# run the shell with quickshell
quickshell shell.qml
```

Theme helpers:

```bash
python scripts/generate_colors.py     # build colors.json from an image
./scripts/update_config.sh             # apply config changes
```

## License

MIT
