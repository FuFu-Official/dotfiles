import QtQuick
import Quickshell
import Quickshell.Io

// ━━━ 网络服务 (nmcli) ━━━
Item {
    id: root

    property string connectionType: "disconnected"  // "wifi", "ethernet", "disconnected"
    property string ssid: ""
    property int signalStrength: 0
    property string ipAddress: ""

    // 网络图标
    readonly property string icon: {
        if (connectionType === "ethernet") return "󰈀"
        if (connectionType === "wifi") {
            if (signalStrength >= 80) return "󰤨"
            if (signalStrength >= 60) return "󰤥"
            if (signalStrength >= 40) return "󰤢"
            if (signalStrength >= 20) return "󰤟"
            return "󰤯"
        }
        return "󰤮"
    }

    readonly property bool connected: connectionType !== "disconnected"

    // 定时刷新
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: networkProc.running = true
    }

    Process {
        id: networkProc
        command: [Quickshell.shellPath("scripts/network.sh")]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.split("|")
                root.connectionType = parts[0] || "disconnected"
                root.ssid = parts[1] || ""
                root.signalStrength = parseInt(parts[2]) || 0
                root.ipAddress = parts[3] || ""
            }
        }
    }
}
