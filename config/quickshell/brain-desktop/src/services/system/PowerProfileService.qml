pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string currentProfile: "balanced"

    Process {
        id: readProc
        command: ["powerprofilesctl", "get"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                var profile = data.trim()
                if (profile !== "")
                    root.currentProfile = profile
            }
        }
    }

    Process {
        id: setProc
        command: []
        running: false
        onExited: root.readProfile()
    }

    Process {
        id: loadProc
        command: [
            "bash",
            "-c",
            "mkdir -p \"$HOME/.config/Brain_Shell/src/user_data\"; " +
            "if [ -f \"$HOME/.config/Brain_Shell/src/user_data/system_settings.json\" ]; then " +
            "cat \"$HOME/.config/Brain_Shell/src/user_data/system_settings.json\"; " +
            "else echo '{}'; fi"
        ]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(text.trim() || "{}")
                    if (data.powerProfile !== undefined) {
                        var profile = String(data.powerProfile)
                        if (
                            profile === "performance" ||
                            profile === "balanced" ||
                            profile === "power-saver"
                        ) {
                            root.setProfile(profile)
                            return
                        }
                    }
                } catch (e) {
                    console.warn("PowerProfileService: failed to load saved profile:", e)
                }
                root.readProfile()
            }
        }
    }

    Process {
        id: saveProc
        command: []
        running: false
    }

    function readProfile() {
        readProc.running = false
        readProc.running = true
    }

    function saveProfile(profile) {
        var json = JSON.stringify({ powerProfile: profile })
        saveProc.command = [
            "bash",
            "-c",
            "mkdir -p \"$HOME/.config/Brain_Shell/src/user_data\" && " +
            "printf '%s' \"$1\" > \"$HOME/.config/Brain_Shell/src/user_data/system_settings.json\"",
            "bash",
            json
        ]
        saveProc.running = false
        saveProc.running = true
    }

    function setProfile(profile) {
        if (
            profile !== "performance" &&
            profile !== "balanced" &&
            profile !== "power-saver"
        )
            return

        setProc.command = ["powerprofilesctl", "set", profile]
        setProc.running = false
        setProc.running = true
        saveProfile(profile)
    }

    Component.onCompleted: loadProc.running = true
}
