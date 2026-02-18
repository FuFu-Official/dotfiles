import QtQuick
import Quickshell.Hyprland

import "../common" as Common

// ━━━ 活动窗口名称 ━━━
Item {
    id: root

    implicitWidth: Math.min(windowLabel.implicitWidth + 8, 200)
    height: parent ? parent.height : Common.Appearance.barHeight

    property string windowTitle: Hyprland.activeToplevel?.title ?? ""

    Text {
        id: windowLabel
        anchors.centerIn: parent
        width: parent.width - 8
        text: root.windowTitle
        color: Common.Appearance.surfaceFg
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeSmall
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        opacity: 0.85
    }
}
