#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/geek-rice-backup-$(date +%Y%m%d-%H%M%S)"

info() { printf "\033[1;36m==>\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33mWARNING:\033[0m %s\n" "$1"; }
fail() { printf "\033[1;31mERROR:\033[0m %s\n" "$1" >&2; exit 1; }

[[ $EUID -ne 0 ]] || fail "Do not run this installer as root."
[[ -f /etc/arch-release ]] || fail "Geek Rice currently targets Arch Linux."

for cmd in git pacman sudo; do
    command -v "$cmd" >/dev/null 2>&1 || fail "Missing required command: $cmd"
done

if ! command -v ryoku >/dev/null 2>&1; then
    fail "Ryoku is required. Install Ryoku first, then run this installer again."
fi

info "Detected Ryoku: $(ryoku version 2>/dev/null || printf "unknown")"

info "Checking required packages..."
mapfile -t PACKAGES < <(grep -Ev "^[[:space:]]*(#|$)" "$REPO_DIR/packages/pacman.txt")

MISSING_PACKAGES=()
INSTALLED_PACKAGES=()

for package in "${PACKAGES[@]}"; do
    if pacman -Qq "$package" >/dev/null 2>&1; then
        INSTALLED_PACKAGES+=("$package")
    else
        MISSING_PACKAGES+=("$package")
    fi
done

printf "\nPackages declared by Geek Rice:\n"
for package in "${PACKAGES[@]}"; do
    printf "  - %s\n" "$package"
done

printf "\nAlready installed: %d package(s)\n" "${#INSTALLED_PACKAGES[@]}"
printf "Packages to install: %d package(s)\n" "${#MISSING_PACKAGES[@]}"

if ((${#MISSING_PACKAGES[@]})); then
    printf "\nMissing packages:\n"
    for package in "${MISSING_PACKAGES[@]}"; do
        printf "  + %s\n" "$package"
    done

    printf "\nGeek Rice needs the missing packages listed above. Continue? [Y/n] "
    read -r answer
    case "${answer:-Y}" in
        Y|y|YES|yes|Yes)
            info "Installing required packages..."
            sudo pacman -S --needed -- "${MISSING_PACKAGES[@]}"
            ;;
        N|n|NO|no|No)
            fail "Installation cancelled by user."
            ;;
        *)
            fail "Please answer Y or N. Installation cancelled."
            ;;
    esac
else
    info "All required packages are already installed."
fi

info "Creating configuration backup..."
mkdir -p "$BACKUP_DIR"

BACKUP_ITEMS=(
    "Brain_Shell"
    "cava"
    "fastfetch"
    "fish"
    "ghostty"
    "gtk-3.0"
    "gtk-4.0"
    "hypr"
    "hyprland-preview-share-picker"
    "kitty"
    "matugen"
    "micro"
    "nvim"
    "qt5ct"
    "qt6ct"
    "quickshell/brain-desktop"
    "ryoku/user_edits"
    "wayle"
    "xsettingsd"
    "yazi"
)

for item in "${BACKUP_ITEMS[@]}"; do
    src="$CONFIG_DIR/$item"
    if [[ -e "$src" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$item")"
        cp -a "$src" "$BACKUP_DIR/$item"
    fi
done

info "Installing Geek configuration..."
mkdir -p "$CONFIG_DIR"
cp -a "$REPO_DIR/config/." "$CONFIG_DIR/"

info "Installing Geek rice presets..."
mkdir -p "$CONFIG_DIR/ryoku/rices"
cp -a "$REPO_DIR/rice/ryoku/." "$CONFIG_DIR/ryoku/rices/"

info "Installing user services..."
USER_SYSTEMD="$CONFIG_DIR/systemd/user"
mkdir -p "$USER_SYSTEMD"
cp -a "$REPO_DIR/systemd/." "$USER_SYSTEMD/"
systemctl --user daemon-reload

if systemctl --user cat brain-desktop.service >/dev/null 2>&1; then
    systemctl --user enable brain-desktop.service >/dev/null
fi

if systemctl --user cat cliphist-wipe.service >/dev/null 2>&1; then
    systemctl --user enable cliphist-wipe.service >/dev/null
fi

if command -v voxtype >/dev/null 2>&1 && systemctl --user cat voxtype.service >/dev/null 2>&1; then
    systemctl --user enable voxtype.service >/dev/null
else
    warn "Voxtype not installed; skipping voxtype.service."
fi

info "Reloading Ryoku..."
ryoku reload || warn "Ryoku reload failed; restart the Hyprland session manually."

echo
printf "Geek Rice installation complete.\n"
printf "Backup: %s\n" "$BACKUP_DIR"
echo
printf "Next step:\n"
printf "  Open Ryoku Hub → Rices → select a Geek rice → Apply.\n"