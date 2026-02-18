import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../common" as Common

// ━━━ Cava 音频可视化 ━━━
Rectangle {
    id: root

    color: Common.Appearance.surfaceContainerHigh
    Layout.fillHeight: true
    implicitWidth: cavaLabel.implicitWidth + Common.Appearance.itemPadding * 2

    property string cavaOutput: " "

    Text {
        id: cavaLabel
        anchors.centerIn: parent
        text: root.cavaOutput
        color: Common.Appearance.primary
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeNormal
    }

    Process {
        id: cavaProc
        command: ["bash", "-c", "~/.config/waybar/.scripts/cava.sh"]
        running: true
        stdout: SplitParser {
            onRead: data => { root.cavaOutput = data || " " }
        }
    }

    Component.onCompleted: cavaProc.running = true
}
