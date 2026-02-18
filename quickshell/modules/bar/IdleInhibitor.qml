import QtQuick
import QtQuick.Layouts
import Quickshell

import "../common" as Common

// ━━━ Idle Inhibitor 按钮 ━━━
Rectangle {
    id: root

    color: Common.Appearance.tertiary
    Layout.fillHeight: true
    implicitWidth: Common.Appearance.barHeight * 0.9

    property bool inhibited: false

    Text {
        anchors.centerIn: parent
        text: root.inhibited ? "" : ""
        color: Common.Appearance.tertiaryFg
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeIcon
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.inhibited = !root.inhibited
            if (root.inhibited)
                Quickshell.execDetached("systemctl --user stop hypridle.service")
            else
                Quickshell.execDetached("systemctl --user start hypridle.service")
        }
    }
}
