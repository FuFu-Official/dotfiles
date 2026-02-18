//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import QtQuick
import Quickshell

import "modules/bar" as Bar
import "services" as Services

ShellRoot {
    id: root

    // ━━━ Services (全局单例，在 bar 等模块中使用) ━━━
    Services.DateTime { id: dateTimeService }
    Services.Audio { id: audioService }
    Services.Battery { id: batteryService }
    Services.Network { id: networkService }
    Services.Bluetooth { id: bluetoothService }
    Services.Brightness { id: brightnessService }

    // ━━━ Bar 面板 ━━━
    Bar.Bar {}
}
