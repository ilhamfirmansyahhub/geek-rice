pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property real barOpacity: 0.85

    signal settingsChanged()

    property var loadProc: Process {
        command: [
            "bash",
            "-c",
            "mkdir -p \"$HOME/.config/Brain_Shell/src/user_data\"; " +
            "if [ -f \"$HOME/.config/Brain_Shell/src/user_data/brain_desktop_settings.json\" ]; then " +
            "cat \"$HOME/.config/Brain_Shell/src/user_data/brain_desktop_settings.json\"; " +
            "else echo '{}'; fi"
        ]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(text.trim() || "{}")
                    if (data.barOpacity !== undefined) {
                        root.barOpacity = Math.max(
                            0.0,
                            Math.min(1.0, Number(data.barOpacity))
                        )
                    }
                } catch (e) {
                    console.warn("SettingsService: failed to load settings:", e)
                }
            }
        }
    }

    property var saveProc: Process {
        command: []
        running: false
    }

    Component.onCompleted: {
        loadProc.running = true
    }

    function save() {
        var json = JSON.stringify({
            barOpacity: root.barOpacity
        })

        saveProc.command = [
            "bash",
            "-c",
            "mkdir -p \"$HOME/.config/Brain_Shell/src/user_data\" && " +
            "printf '%s' \"$1\" > \"$HOME/.config/Brain_Shell/src/user_data/brain_desktop_settings.json\"",
            "bash",
            json
        ]

        saveProc.running = false
        saveProc.running = true
    }

    function setBarOpacity(value) {
        barOpacity = Math.max(
            0.0,
            Math.min(1.0, Number(value))
        )

        save()
        settingsChanged()
    }
}
