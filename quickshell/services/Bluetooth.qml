import QtQuick
import Quickshell
import Quickshell.Io

// ━━━ 蓝牙服务 ━━━
Item {
    id: root

    property bool powered: false
    property bool connected: false
    property string deviceName: ""

    readonly property string icon: {
        if (!powered) return "󰂲"
        if (connected) return "󰂱"
        return "󰂯"
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: btProc.running = true
    }

    Process {
        id: btProc
        command: [Quickshell.shellPath("scripts/bluetooth.sh")]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.split("|")
                root.powered = parts[0] === "on"
                root.connected = parts[1] === "connected"
                root.deviceName = parts[2] || ""
            }
        }
    }
}
