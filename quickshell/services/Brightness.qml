import QtQuick
import Quickshell
import Quickshell.Io

// ━━━ 亮度服务 ━━━
Item {
    id: root

    property int brightness: 100
    property int maxBrightness: 100

    readonly property real percentage: maxBrightness > 0 ? brightness / maxBrightness : 1.0
    readonly property int percentInt: Math.round(percentage * 100)

    readonly property string icon: {
        if (percentInt >= 80) return "󰃠"
        if (percentInt >= 50) return "󰃟"
        return "󰃞"
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: brightnessProc.running = true
    }

    Process {
        id: brightnessProc
        command: [Quickshell.shellPath("scripts/brightness.sh")]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.split("|")
                root.brightness = parseInt(parts[0]) || 0
                root.maxBrightness = parseInt(parts[1]) || 100
            }
        }
    }

    function increase() { Quickshell.execDetached("brightnessctl set 5%+") }
    function decrease() { Quickshell.execDetached("brightnessctl set 5%-") }
}
