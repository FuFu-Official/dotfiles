import QtQuick
import Quickshell
import Quickshell.Wayland

import "../common" as Common

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 顶部栏面板 - PanelWindow 包装
// 参考 end-4/dots-hyprland 的 Bar.qml
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Scope {
    id: barRoot

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow

            property var modelData

            screen: modelData
            visible: BarState.visible

            WlrLayershell.namespace: "quickshell:bar"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.margins.top: Common.Appearance.barMargin
            WlrLayershell.margins.left: Common.Appearance.barMargin
            WlrLayershell.margins.right: Common.Appearance.barMargin

            anchors {
                top: true
                left: true
                right: true
            }

            exclusionMode: ExclusionMode.Normal
            exclusiveZone: Common.Appearance.barHeight + Common.Appearance.barMargin

            implicitHeight: Common.Appearance.barHeight
            color: "transparent"

            // 内容
            BarContent {
                anchors.fill: parent
            }
        }
    }
}
