import QtQuick
import "../../"
import "../../components"
import "../../services/system"

Item {
    id: root

    required property var cpuFreqService

    readonly property string currentProfile:
        PowerProfileService.currentProfile

    function setPowerProfile(profile) {
        PowerProfileService.setProfile(profile)
    }

    Column {
        anchors.centerIn: parent
        spacing: 16

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 5

                Text {
                    text: "󰌾"
                    font.pixelSize: 11
                    color: Qt.rgba(1, 1, 1, 0.25)
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "Power Profile"
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    color: Qt.rgba(1, 1, 1, 0.4)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6

                ProfileButton {
                    label: "Power Saver"
                    active: root.currentProfile === "power-saver"
                    onClicked: root.setPowerProfile("power-saver")
                }

                ProfileButton {
                    label: "Balanced"
                    active: root.currentProfile === "balanced"
                    onClicked: root.setPowerProfile("balanced")
                }

                ProfileButton {
                    label: "Performance"
                    active: root.currentProfile === "performance"
                    onClicked: root.setPowerProfile("performance")
                }
            }
        }
    }
}
