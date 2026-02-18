import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../common" as Common

// ━━━ 护眼模式按钮 ━━━
Rectangle {
    id: root

    color: Common.Appearance.surfaceContainerHigh
    Layout.fillHeight: true
    implicitWidth: Common.Appearance.barHeight

    property bool active: false

    Text {
        anchors.centerIn: parent
        text: root.active ? "" : ""
        color: Common.Appearance.secondary
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeIcon
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: checkProc.running = true
    }

    Process {
        id: checkProc
        command: ["bash", "-c", "hyprshade current | grep -q blue-light-filter && echo on || echo off"]
        stdout: SplitParser {
            onRead: data => { root.active = data.trim() === "on" }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached("hyprshade toggle blue-light-filter")
    }
}
