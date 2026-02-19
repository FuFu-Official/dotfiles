import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import "../common" as Common

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Bar 内容 - 浮动 pill 分组布局
// 参考 end-4/dots-hyprland 风格
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Item {
    id: barContent

    RowLayout {
        anchors.fill: parent
        spacing: Common.Appearance.groupGap

        // ═══ 左：工作区 ═══
        BarGroup {
            Workspaces {}
        }

        // ═══ 左：活动窗口 ═══
        BarGroup {
            visible: (Hyprland.activeToplevel?.title ?? "") !== ""
            ActiveWindow {}
        }

        // ═══ 左：媒体播放 (有播放时显示) ═══
        BarGroup {
            visible: mediaService?.hasPlayer ?? false
            MediaWidget {}
        }

        Item { Layout.fillWidth: true }

        // ═══ 中：时钟 (点击开关日历) ═══
        BarGroup {
            ClockWidget {}
        }

        Item { Layout.fillWidth: true }

        // ═══ 右：系统状态 (右键任意图标开关 Quick Settings) ═══
        BarGroup {
            NetworkWidget {}
            BluetoothWidget {}
            BrightnessWidget {}
            AudioWidget {}
        }

        // ═══ 右：系统控制 ═══
        BarGroup {
            SysTray {}
            BatteryWidget {}
            PowerMenu {}
        }
    }
}
