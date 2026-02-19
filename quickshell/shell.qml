//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import QtQuick
import Quickshell

import "modules/bar" as Bar
import "modules/osd" as Osd
import "modules/panel" as Panel
import "services" as Services

ShellRoot {
    id: root

    // ━━━ Services (全局单例，在 bar / panel 等模块中使用) ━━━
    Services.DateTime { id: dateTimeService }
    Services.Audio { id: audioService }
    Services.Battery { id: batteryService }
    Services.Network { id: networkService }
    Services.Bluetooth { id: bluetoothService }
    Services.Brightness { id: brightnessService }
    Services.MediaPlayer { id: mediaService }

    // ━━━ Bar 面板 ━━━
    Bar.Bar {}

    // ━━━ OSD 浮动提示 (音量/亮度调节时自动显示) ━━━
    Osd.Osd {
        currentVolume: audioService.volume
        currentMuted: audioService.muted
        currentBrightness: brightnessService.percentInt
        volumeIcon: audioService.volumeIcon
        brightnessIcon: brightnessService.icon
    }

    // ━━━ 快捷设置面板 (从 bar 右侧弹出) ━━━
    Panel.QuickSettings {}

    // ━━━ 日历面板 (从时钟弹出) ━━━
    Panel.CalendarPopup {}
}
