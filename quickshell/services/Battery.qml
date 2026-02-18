import QtQuick
import Quickshell.Services.UPower

// ━━━ 电池服务 (UPower) ━━━
Item {
    id: root

    readonly property real percentage: UPower.displayDevice.percentage
    readonly property int percentInt: Math.round(percentage * 100)
    readonly property bool isCharging: UPower.displayDevice.state === UPowerDeviceState.Charging
                                      || UPower.displayDevice.state === UPowerDeviceState.FullyCharged
    readonly property bool isLow: percentInt <= 20
    readonly property bool isCritical: percentInt <= 10
    readonly property bool isFullyCharged: UPower.displayDevice.state === UPowerDeviceState.FullyCharged

    // 电池图标 (Nerd Font)
    readonly property string icon: {
        if (isCharging) return "󰂄"
        if (percentInt >= 90) return "󰁹"
        if (percentInt >= 80) return "󰂂"
        if (percentInt >= 70) return "󰂀"
        if (percentInt >= 60) return "󰁿"
        if (percentInt >= 50) return "󰁾"
        if (percentInt >= 40) return "󰁽"
        if (percentInt >= 30) return "󰁼"
        if (percentInt >= 20) return "󰁻"
        if (percentInt >= 10) return "󰁺"
        return "󰂎"
    }
}
