import QtQuick
import QtQuick.Controls as QC
import Quickshell

import "../common" as Common

// ━━━ 蓝牙图标 ━━━
Item {
    id: root

    implicitWidth: 24
    height: parent ? parent.height : Common.Appearance.barHeight

    property string icon: bluetoothService?.icon ?? "󰂯"

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
                Quickshell.execDetached("bluetoothctl power toggle")
            else
                Quickshell.execDetached("kitty --class bluetui -e bluetui")
        }

        QC.ToolTip {
            id: btTip
            visible: parent.containsMouse
            text: {
                if (!bluetoothService) return "Bluetooth"
                if (bluetoothService.connected) return bluetoothService.deviceName
                if (bluetoothService.powered) return "Bluetooth On"
                return "Bluetooth Off"
            }
            delay: 300
            background: Rectangle { color: Common.Appearance.surfaceContainerHigh; radius: 8 }
            contentItem: Text {
                color: Common.Appearance.surfaceFg
                font.family: Common.Appearance.font.family
                font.pixelSize: Common.Appearance.font.sizeSmall
                text: btTip.text
            }
        }
    }
}
