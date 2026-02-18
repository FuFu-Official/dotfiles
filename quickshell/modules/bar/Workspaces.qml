import QtQuick
import Quickshell
import Quickshell.Hyprland

import "../common" as Common

// ━━━ Hyprland 工作区 - 动画圆点指示器 ━━━
// end-4 风格：活跃工作区 → 长条 pill，占用 → 小圆点
Item {
    id: root

    implicitWidth: wsRow.implicitWidth
    height: parent ? parent.height : Common.Appearance.barHeight

    property int activeId: Hyprland.focusedWorkspace?.id ?? 1

    property var occupiedIds: {
        let ids = []
        for (const ws of Hyprland.workspaces.values) {
            if (ws.id > 0) ids.push(ws.id)
        }
        return ids.sort((a, b) => a - b)
    }

    Row {
        id: wsRow
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: 10

            Rectangle {
                id: wsDot

                required property int index
                property int wsId: index + 1
                property bool isActive: root.activeId === wsId
                property bool isOccupied: root.occupiedIds.indexOf(wsId) >= 0

                visible: isOccupied || isActive
                width: isActive ? 24 : 8
                height: 8
                radius: 4
                anchors.verticalCenter: parent.verticalCenter
                color: isActive ? Common.Appearance.primary : Common.Appearance.surfaceVariantFg

                Behavior on width {
                    NumberAnimation { duration: Common.Appearance.animDuration; easing.type: Easing.OutCubic }
                }
                Behavior on color {
                    ColorAnimation { duration: Common.Appearance.animDuration }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + wsDot.wsId)
                }
            }
        }
    }

    // 滚轮切换工作区
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        acceptedButtons: Qt.NoButton
        onWheel: event => {
            if (event.angleDelta.y > 0) Hyprland.dispatch("workspace r-1")
            else Hyprland.dispatch("workspace r+1")
        }
    }
}
