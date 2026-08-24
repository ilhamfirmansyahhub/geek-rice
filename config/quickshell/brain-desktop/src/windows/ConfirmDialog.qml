import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../"
import "../services/"

PanelWindow {
    id: root

    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    exclusionMode: ExclusionMode.Ignore
    visible: Popups.confirmOpen || Popups.confirmRunning

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    Process {
        id: proc
        property var pendingCmd: []
        command: pendingCmd

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                Popups.confirmRunning = false
                Popups.cancelConfirm()
            } else {
                Popups.confirmRunning = false
            }
        }
    }

    function confirm() {
        const powerScript = Quickshell.shellDir + "/src/scripts/PowerControl.sh"

        switch (Popups.confirmAction) {
            case "shutdown":
                Popups.cancelConfirm()
                proc.pendingCmd = ["bash", powerScript, "shutdown"]
                proc.running = true
                break
            case "reboot":
                Popups.cancelConfirm()
                proc.pendingCmd = ["bash", powerScript, "reboot"]
                proc.running = true
                break
            case "logout":
                Popups.cancelConfirm()
                proc.pendingCmd = ["bash", powerScript, "logout"]
                proc.running = true
                break
            case "lock":
                Popups.cancelConfirm()
                proc.pendingCmd = ["loginctl", "lock-session"]
                proc.running = true
                break
            case "suspend":
                Popups.cancelConfirm()
                proc.pendingCmd = ["systemctl", "suspend"]
                proc.running = true
                break
            case "change-avatar":
                ProfileService.confirmAvatar()
                Popups.cancelConfirm()
                break
        }
    }

    function cancel() {
        if (!Popups.confirmRunning)
            Popups.cancelConfirm()
    }

    Rectangle {
        anchors.fill: parent
        color: "#99000000"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!Popups.confirmRunning)
                    root.cancel()
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 360
        height: col.implicitHeight + 48
        radius: Theme.notchRadius
        color: Theme.background
        visible: Popups.confirmOpen && !Popups.confirmRunning

        MouseArea { anchors.fill: parent }

        Column {
            id: col
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 24
                leftMargin: 24
                rightMargin: 24
            }
            spacing: 16

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    switch (Popups.confirmAction) {
                        case "shutdown": return "⏻"
                        case "reboot": return "↺"
                        case "logout": return "⎋"
                        default: return "⚠️"
                    }
                }
                font.pixelSize: 32
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Popups.confirmTitle
                color: Theme.text
                font.pixelSize: 15
                font.bold: true
            }

            Text {
                width: parent.width
                text: Popups.confirmMessage
                color: Qt.rgba(1, 1, 1, 0.65)
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                lineHeight: 1.4
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                Rectangle {
                    width: 130
                    height: 38
                    radius: Theme.cornerRadius
                    color: cancelHov.hovered ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(1, 1, 1, 0.05)

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: Theme.text
                        font.pixelSize: 13
                    }

                    HoverHandler {
                        id: cancelHov
                        cursorShape: Qt.PointingHandCursor
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.cancel()
                    }
                }

                Rectangle {
                    width: 130
                    height: 38
                    radius: Theme.cornerRadius
                    color: confirmHov.hovered ? "#cc3a3a" : "#993030"

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.centerIn: parent
                        text: Popups.confirmLabel
                        color: "white"
                        font.pixelSize: 13
                        font.bold: true
                    }

                    HoverHandler {
                        id: confirmHov
                        cursorShape: Qt.PointingHandCursor
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.confirm()
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 300
        height: processingCol.implicitHeight + 56
        radius: Theme.notchRadius
        color: Theme.background
        visible: Popups.confirmRunning

        MouseArea { anchors.fill: parent }

        Column {
            id: processingCol
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 28
                leftMargin: 24
                rightMargin: 24
            }
            spacing: 18

            Canvas {
                id: spinnerCanvas
                anchors.horizontalCenter: parent.horizontalCenter
                width: 40
                height: 40

                RotationAnimator {
                    target: spinnerCanvas
                    from: 0
                    to: 360
                    duration: 900
                    loops: Animation.Infinite
                    running: Popups.confirmRunning
                    easing.type: Easing.Linear
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    var cx = width / 2
                    var cy = height / 2
                    var r = 16

                    ctx.beginPath()
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                    ctx.strokeStyle = "rgba(255,255,255,0.1)"
                    ctx.lineWidth = 3
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(cx, cy, r, -Math.PI / 2, Math.PI)
                    ctx.strokeStyle = "white"
                    ctx.lineWidth = 3
                    ctx.lineCap = "round"
                    ctx.stroke()
                }

                Component.onCompleted: requestPaint()
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Applying Changes"
                color: Theme.text
                font.pixelSize: 15
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                text: "Applying system change..."
                color: Qt.rgba(1, 1, 1, 0.55)
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Item {
        anchors.fill: parent
        focus: root.visible
        Keys.onReturnPressed: root.confirm()
        Keys.onEscapePressed: root.cancel()
    }
}
