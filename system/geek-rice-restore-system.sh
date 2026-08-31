#!/usr/bin/env bash
set -euo pipefail

# Geek Rice system-level persistence helper.
# Restores user-selected SDDM and Plymouth state after packages that may
# regenerate or replace their configuration.

# -----------------------------
# SDDM
# -----------------------------

install -d -m 755 /etc/sddm.conf.d

cat > /etc/sddm.conf.d/99-geek-rice.conf <<'EOF'
[General]
DisplayServer=x11

[Theme]
Current=elarun
CursorTheme=Adwaita
CursorSize=24
EOF

# -----------------------------
# Plymouth
# -----------------------------

if command -v plymouth-set-default-theme >/dev/null 2>&1; then
    current_theme="$(plymouth-set-default-theme 2>/dev/null || true)"

    if [[ "$current_theme" != "tux" ]]; then
        plymouth-set-default-theme tux
        mkinitcpio -P
    fi
fi
