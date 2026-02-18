import QtQuick
import QtQuick.Layouts
import Quickshell

import "../common" as Common

// ━━━ 截图按钮 ━━━
Rectangle {
    id: root

    color: Common.Appearance.surfaceContainerHigh
    Layout.fillHeight: true
    implicitWidth: Common.Appearance.barHeight

    Text {
        anchors.centerIn: parent
        text: ""
        color: Common.Appearance.secondary
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeXLarge
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                Quickshell.execDetached("hyprshot -m region")
            else if (mouse.button === Qt.RightButton)
                Quickshell.execDetached("hyprshot -m window")
            else
                Quickshell.execDetached("thunar $HOME/Pictures/Screenshots")
        }
    }
}
