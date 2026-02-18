import QtQuick
import Quickshell

import "../common" as Common

// ━━━ 电源按钮 ━━━
Item {
    id: root

    implicitWidth: 24
    height: parent ? parent.height : Common.Appearance.barHeight

    Text {
        anchors.centerIn: parent
        text: "󰐥"
        color: Common.Appearance.error
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeIcon
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached("wlogout")
    }
}
