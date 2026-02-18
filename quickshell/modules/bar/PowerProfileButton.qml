import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QC
import Quickshell
import Quickshell.Io

import "../common" as Common

// ━━━ 电源配置按钮 ━━━
Rectangle {
    id: root

    color: Common.Appearance.tertiary
    Layout.fillHeight: true
    implicitWidth: Common.Appearance.barHeight * 0.9

    property string profile: "balanced"  // "performance", "balanced", "power-saver"

    readonly property string profileIcon: {
        if (profile === "performance") return "󱐋"
        if (profile === "power-saver") return ""
        return ""
    }

    readonly property color iconColor: {
        if (profile === "performance") return Common.Appearance.errorFg
        return Common.Appearance.tertiaryFg
    }

    Text {
        anchors.centerIn: parent
        text: root.profileIcon
        color: root.iconColor
        font.family: Common.Appearance.font.family
        font.pixelSize: root.profile === "performance" ? Common.Appearance.font.sizeXLarge : Common.Appearance.font.sizeIcon
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: profileProc.running = true
    }

    Process {
        id: profileProc
        command: ["powerprofilesctl", "get"]
        stdout: SplitParser {
            onRead: data => { root.profile = data.trim() }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
            // 循环切换 balanced → performance → power-saver
            if (root.profile === "balanced")
                Quickshell.execDetached("powerprofilesctl set performance")
            else if (root.profile === "performance")
                Quickshell.execDetached("powerprofilesctl set power-saver")
            else
                Quickshell.execDetached("powerprofilesctl set balanced")
        }

        QC.ToolTip {
            id: powerTooltip
            visible: parent.containsMouse
            text: "Power: " + root.profile
            delay: 300

            background: Rectangle {
                color: Common.Appearance.secondaryContainer
                border.color: Common.Appearance.outline
                border.width: 1
                radius: 4
            }

            contentItem: Text {
                color: Common.Appearance.surfaceFg
                font.family: Common.Appearance.font.family
                font.pixelSize: Common.Appearance.font.sizeSmall
                text: powerTooltip.text
            }
        }
    }
}
