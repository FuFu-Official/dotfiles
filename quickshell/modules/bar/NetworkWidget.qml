import QtQuick
import QtQuick.Controls as QC
import Quickshell

import "../common" as Common

// ━━━ 网络图标 ━━━
Item {
    id: root

    implicitWidth: 24
    height: parent ? parent.height : Common.Appearance.barHeight

    property string icon: networkService?.icon ?? "󰤮"

    Text {
        anchors.centerIn: parent
        text: root.icon
        color: Common.Appearance.surfaceFg
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeIcon
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                Quickshell.execDetached("kitty --class nmtui -e nmtui")
            else
                Quickshell.execDetached("nm-connection-editor")
        }

        QC.ToolTip {
            id: netTip
            visible: parent.containsMouse
            text: {
                if (!networkService) return "Network"
                if (networkService.connectionType === "wifi")
                    return networkService.ssid + " (" + networkService.signalStrength + "%)"
                if (networkService.connectionType === "ethernet")
                    return "Ethernet · " + networkService.ipAddress
                return "Disconnected"
            }
            delay: 300
            background: Rectangle { color: Common.Appearance.surfaceContainerHigh; radius: 8 }
            contentItem: Text {
                color: Common.Appearance.surfaceFg
                font.family: Common.Appearance.font.family
                font.pixelSize: Common.Appearance.font.sizeSmall
                text: netTip.text
            }
        }
    }
}
