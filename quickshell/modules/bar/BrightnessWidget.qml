import QtQuick
import QtQuick.Controls as QC
import Quickshell

import "../common" as Common

// ━━━ 亮度图标 (滚轮调节) ━━━
Item {
    id: root

    implicitWidth: 24
    height: parent ? parent.height : Common.Appearance.barHeight

    property string icon: brightnessService?.icon ?? "󰃟"
    property int percent: brightnessService?.percentInt ?? 100

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

        onWheel: event => {
            if (event.angleDelta.y > 0)
                Quickshell.execDetached("brightnessctl set 5%+")
            else
                Quickshell.execDetached("brightnessctl set 5%-")
        }

        QC.ToolTip {
            id: brightTip
            visible: parent.containsMouse
            text: "Brightness: " + root.percent + "%"
            delay: 300
            background: Rectangle { color: Common.Appearance.surfaceContainerHigh; radius: 8 }
            contentItem: Text {
                color: Common.Appearance.surfaceFg
                font.family: Common.Appearance.font.family
                font.pixelSize: Common.Appearance.font.sizeSmall
                text: brightTip.text
            }
        }
    }
}
