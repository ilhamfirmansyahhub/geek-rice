# Geek Rice

Public Arch Linux / Hyprland rice by geek, built around Ryoku, Brain_Shell and Brain Desktop.

## What this is

Geek Rice is a reproducible desktop setup. It contains the configuration, themes, wallpapers, widgets, scripts, services and Ryoku rice presets used by my desktop.

This is not a backup of my whole home directory.

## Requirements

- Arch Linux
- Ryoku installed and working
- A working Hyprland session

## Installation

Clone the repository:

```bash
git clone <REPOSITORY-URL>
cd geek-rice
```

Run the installer:

```bash
./install.sh
```

The installer:

1. Installs the required packages.
2. Backs up conflicting Geek configuration paths.
3. Installs the Geek configuration.
4. Installs the Geek Ryoku rice presets.
5. Installs the required user services.
6. Reloads Ryoku.

## Apply the Geek look

After installation, open the Ryoku Hub and go to the Rices section.

Choose one of the included presets:

- `geek-rice`
- `geek-brain-shell-desktop-rice`

Then press Apply.

Ryoku rice presets are designed to capture and apply the desktop look while keeping unrelated user and machine state separate.

## Included

- Hyprland
- Brain_Shell
- Brain Desktop / Quickshell
- Ryoku rice presets
- Matugen
- GTK / Qt theming
- Kitty / Ghostty
- Fish
- Fastfetch
- Cava
- Yazi
- Neovim
- user services

## Safety

Private credentials, browser data, caches, runtime state and machine-specific secrets are intentionally excluded.

Existing conflicting configuration is backed up before installation.

## Author

geek
