import QtQuick
import Quickshell.Io

QtObject {
    id: root

    // Read-only GPU status provider.
    // Brain Desktop does not switch GPU modes anymore.
    property string currentMode: "integrated"

    property var queryProc: Process {
        command: [
            "envycontrol",
            "--query"
        ]

        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                var mode = text.trim().toLowerCase()

                if (
                    mode === "integrated" ||
                    mode === "hybrid" ||
                    mode === "nvidia"
                ) {
                    root.currentMode = mode
                }
            }
        }
    }

    function queryMode() {
        queryProc.running = false
        queryProc.running = true
    }

    Component.onCompleted: {
        queryMode()
    }
}
