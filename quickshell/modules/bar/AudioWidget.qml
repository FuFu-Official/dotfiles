import QtQuick
import QtQuick.Controls as QC
import Quickshell

import "../common" as Common

// ━━━ 音量图标 (滚轮调节, 左键静音, 右键麦克风, 中键 pavucontrol) ━━━
Item {
    id: root

    implicitWidth: 24
    height: parent ? parent.height : Common.Appearance.barHeight

    property string icon: audioService?.volumeIcon ?? ""
    property int percent: audioService?.volumePercent ?? 0
    property bool muted: audioService?.muted ?? false

    Text {
        anchors.centerIn: parent
        text: root.icon
        color: root.muted ? Common.Appearance.surfaceVariantFg : Common.Appearance.surfaceFg
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeIcon
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                if (audioService) audioService.toggleMute()
            } else if (mouse.button === Qt.RightButton) {
                BarState.toggleQuickSettings()
            } else {
                Quickshell.execDetached("pavucontrol")
            }
        }

        onWheel: event => {
            if (!audioService) return
            if (event.angleDelta.y > 0) audioService.increaseVolume()
            else audioService.decreaseVolume()
        }

        QC.ToolTip {
            id: volTip
            visible: parent.containsMouse
            text: "Volume: " + root.percent + "%"
            delay: 300
            background: Rectangle { color: Common.Appearance.surfaceContainerHigh; radius: 8 }
            contentItem: Text {
                color: Common.Appearance.surfaceFg
                font.family: Common.Appearance.font.family
                font.pixelSize: Common.Appearance.font.sizeSmall
                text: volTip.text
            }
        }
    }
}
