import QtQuick
import QtQuick.Controls as QC

import "../common" as Common

// ━━━ 电池 ━━━
Item {
    id: root

    implicitWidth: battRow.implicitWidth
    height: parent ? parent.height : Common.Appearance.barHeight

    property int percent: batteryService?.percentInt ?? 50
    property bool charging: batteryService?.isCharging ?? false
    property bool low: batteryService?.isLow ?? false
    property string icon: batteryService?.icon ?? "󰁹"

    Row {
        id: battRow
        anchors.centerIn: parent
        spacing: 3

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.icon
            color: root.low && !root.charging ? Common.Appearance.error : Common.Appearance.surfaceFg
            font.family: Common.Appearance.font.family
            font.pixelSize: Common.Appearance.font.sizeIcon
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.percent + "%"
            color: root.low && !root.charging ? Common.Appearance.error : Common.Appearance.surfaceFg
            font.family: Common.Appearance.font.family
            font.pixelSize: Common.Appearance.font.sizeSmall
        }
    }

    // 低电量脉冲
    SequentialAnimation on opacity {
        loops: Animation.Infinite
        running: root.low && !root.charging
        NumberAnimation { to: 0.5; duration: 500 }
        NumberAnimation { to: 1.0; duration: 500 }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        QC.ToolTip {
            id: battTip
            visible: parent.containsMouse
            text: root.charging ? "Charging " + root.percent + "%" : "Battery " + root.percent + "%"
            delay: 300
            background: Rectangle { color: Common.Appearance.surfaceContainerHigh; radius: 8 }
            contentItem: Text {
                color: Common.Appearance.surfaceFg
                font.family: Common.Appearance.font.family
                font.pixelSize: Common.Appearance.font.sizeSmall
                text: battTip.text
            }
        }
    }
}
