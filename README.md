# Geek Rice
My personal rice, built around Ryoku, Brain_Shell and Brain Desktop.

## What this is

Geek Rice is a reproducible desktop setup. It contains the configuration, themes, wallpapers, widgets, scripts, services and Ryoku rice presets used by my desktop.

This is **not** a backup of my whole home directory.

The goal is simple: install this repository on another Arch Linux + Hyprland system and get as close as practical to my desktop setup without copying private machine state.

## Requirements

- Arch Linux
- Ryoku installed and working
- A working Hyprland session
- An internet connection for package installation

## Installation

Clone the repository:

```bash
git clone https://github.com/ilhamfirmansyahhub/geek-rice.git
cd geek-rice
```

Run the installer:

```bash
./install.sh
```

The installer will:

1. Check that the system is Arch Linux and that Ryoku is installed.
2. Install the packages listed in `packages/pacman.txt`.
3. Back up conflicting Geek configuration paths under `~/.config/geek-rice-backup-*`.
4. Install the Geek configuration, Brain Desktop and related assets.
5. Install the included Ryoku rice presets.
6. Install the included user systemd services.
7. Reload Ryoku.

The installer does **not** run as root and does not intentionally copy browser profiles, credentials, caches or other private home-directory data.

## Apply the Geek look

The installer installs the rice presets, but the final look should be applied through Ryoku itself.

Open **Ryoku Hub → Rices**, then select one of the included presets:

- `geek-rice`
- `geek-brain-shell-desktop-rice`

Press **Apply**.

This separation is intentional: the rice captures the desktop look while Ryoku keeps unrelated machine and user state under its own control.

## What you get

- Hyprland configuration and keybinds
- Brain_Shell integration
- Brain Desktop / Quickshell
- Ryoku rice presets
- Matugen theme integration
- GTK 3 / GTK 4 theming
- Qt 5 / Qt 6 theming
- Kitty / Ghostty configuration
- Fish shell configuration
- Fastfetch
- Cava and visualizer shaders
- Yazi
- Neovim
- User systemd services
- Wallpapers and rice preview assets

## Machine-specific behavior

Some parts of a Linux desktop are inherently hardware- or machine-specific, such as displays, audio devices, GPU features, usernames and optional applications.

The repository intentionally avoids copying private machine state. A clean installation may therefore require small adjustments after installation, especially for hardware-specific integrations.

## Safety and backups

Private credentials, browser data, caches, runtime state and machine-specific secrets are intentionally excluded.

Before replacing an existing configuration, the installer creates a timestamped backup under:

```text
~/.config/geek-rice-backup-YYYYMMDD-HHMMSS/
```

## Credits

This rice includes third-party components:

- Brain_Shell — https://github.com/Brainitech/Brain_Shell — MIT License
- Ryoku — https://github.com/neur0map/ryoku-arch
- Quickshell — https://github.com/quickshell-mirror/quickshell

See `LICENSES/` for included third-party license notices.

## Author

Ilham Firmansyah
