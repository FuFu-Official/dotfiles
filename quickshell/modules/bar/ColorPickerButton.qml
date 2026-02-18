import QtQuick
import QtQuick.Layouts
import Quickshell

import "../common" as Common

// ━━━ 颜色拾取器按钮 ━━━
Rectangle {
    id: root

    color: Common.Appearance.tertiary
    Layout.fillHeight: true
    implicitWidth: Common.Appearance.barHeight * 0.9

    Text {
        anchors.centerIn: parent
        text: "󱏜"
        color: Common.Appearance.tertiaryFg
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeIcon
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached("bash -c 'hyprpicker | wl-copy'")
    }
}
