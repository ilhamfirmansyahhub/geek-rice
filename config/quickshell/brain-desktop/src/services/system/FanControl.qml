import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property string mode: "auto"
    property bool busy: false

    property var proc: Process {
        command: []
        running: false
        onRunningChanged: {
            if (!running)
                root.busy = false
        }
    }

    property var loadProc: Process {
        command: [
            "bash",
            "-c",
            "mkdir -p \"$HOME/.config/Brain_Shell/src/user_data\"; " +
            "if [ -f \"$HOME/.config/Brain_Shell/src/user_data/fan_settings.json\" ]; then " +
            "cat \"$HOME/.config/Brain_Shell/src/user_data/fan_settings.json\"; " +
            "else echo '{}'; fi"
        ]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(text.trim() || "{}")
                    var savedMode = String(data.fanMode || "auto")
                    if (
                        savedMode === "quiet" ||
                        savedMode === "auto" ||
                        savedMode === "max"
                    ) {
                        root.mode = savedMode
                        root.applyMode(savedMode)
                    } else {
                        root.mode = "auto"
                        root.applyMode("auto")
                    }
                } catch (e) {
                    console.warn("FanControl: failed to load saved mode:", e)
                    root.mode = "auto"
                    root.applyMode("auto")
                }
            }
        }
    }

    property var saveProc: Process {
        command: []
        running: false
    }

    function saveMode(mode) {
        var json = JSON.stringify({ fanMode: mode })
        saveProc.command = [
            "bash",
            "-c",
            "mkdir -p \"$HOME/.config/Brain_Shell/src/user_data\" && " +
            "printf '%s' \"$1\" > \"$HOME/.config/Brain_Shell/src/user_data/fan_settings.json\"",
            "bash",
            json
        ]
        saveProc.running = false
        saveProc.running = true
    }

    function applyMode(m) {
        if (m === "quiet")
            proc.command = ["sh", "-c", "timeout 5 nbfc set -s 30"]
        else if (m === "max")
            proc.command = ["sh", "-c", "timeout 5 nbfc set -s 100"]
        else
            proc.command = ["sh", "-c", "timeout 5 nbfc set -a"]

        proc.running = false
        proc.running = true
    }

    function setMode(m) {
        if (busy)
            return

        if (
            m !== "quiet" &&
            m !== "auto" &&
            m !== "max"
        )
            return

        root.mode = m
        root.busy = true
        applyMode(m)
        saveMode(m)
    }

    Component.onCompleted: loadProc.running = true
}
