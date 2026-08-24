pragma Singleton

import QtQuick
import "../"

QtObject {
    property bool audioOpen: false
    property bool networkOpen: false
    property bool batteryOpen: false
    property bool notificationsOpen: false
    property bool archMenuOpen: false
    property bool dashboardOpen: false
    property bool wallpaperOpen: false
    property bool notificationToastOpen: false
    property bool quickOpen: false
    property bool clipboardOpen: false

    property int dashboardPageWidth: 900
    property string dashboardPage: "home"
    property string audioPage: "output"
    property string networkPage: "wifi"

    property bool archMenuTriggerHovered: false
    property bool audioTriggerHovered: false
    property bool networkTriggerHovered: false
    property bool batteryTriggerHovered: false
    property bool notificationsTriggerHovered: false
    property bool wallpaperTriggerHovered: false
    property bool quickTriggerHovered: false

    property int slideDuration: Theme.animDuration
    property int hoverCloseDelay: Theme.animDuration + 200

    property bool confirmOpen: false
    property string confirmTitle: ""
    property string confirmMessage: ""
    property string confirmLabel: "Confirm"
    property string confirmAction: ""
    property bool confirmRunning: false

    function showConfirm(title, message, label, action) {
        confirmTitle = title
        confirmMessage = message
        confirmLabel = label
        confirmAction = action
        confirmOpen = true
    }

    function cancelConfirm() {
        confirmOpen = false
        confirmAction = ""
    }

    readonly property bool anyOpen:
        audioOpen || networkOpen || batteryOpen || notificationsOpen ||
        archMenuOpen || dashboardOpen || wallpaperOpen || quickOpen || clipboardOpen

    function closeAll() {
        audioOpen = false
        networkOpen = false
        batteryOpen = false
        notificationsOpen = false
        archMenuOpen = false
        dashboardOpen = false
        wallpaperOpen = false
        quickOpen = false
        clipboardOpen = false
    }
}
