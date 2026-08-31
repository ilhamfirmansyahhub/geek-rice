import QtQuick
import Quickshell
import "../"

// ============================================================
// PopupLayer — the only file that instantiates popup windows.
// ============================================================

Item {
    id: root

    required property var topBar
    required property var leftBorder
    required property var rightBorder
    required property var bottomBorder

    // ── Border-anchored popups ───────────────────────────────

    ArchMenu {
        anchorWindow: root.leftBorder
    }

    WallpaperPopup {}

    ClipboardPopup {}

    // ── TopBar-anchored popups ───────────────────────────────

    AudioPopup {
        anchorWindow: root.rightBorder
    }

    QuickControl {
        anchorWindow: root.topBar
    }

    Dashboard {
        anchorWindow: root.topBar
    }

    // Brain Desktop notifications are intentionally disabled.
    // Ryoku is the sole desktop notification UI.

    ScreenRecOptionsPopup {
        anchorWindow: root.topBar
    }

    NetworkPopup {}
    BrainSearch {}
}
