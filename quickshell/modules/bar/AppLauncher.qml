import QtQuick
import QtQuick.Layouts
import Quickshell

import "../common" as Common

// ━━━ 应用启动器按钮 ━━━
Rectangle {
    id: root

    color: Common.Appearance.primary
    Layout.fillHeight: true
    implicitWidth: Common.Appearance.barHeight * 1.1

    Text {
        anchors.centerIn: parent
        text: "󰣇"
        color: Common.Appearance.primaryFg
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeHuge
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached("walker")
    }

    // 悬浮效果
    states: State {
        name: "hovered"
        when: hoverArea.containsMouse
        PropertyChanges { target: root; color: Qt.lighter(Common.Appearance.primary, 1.15) }
    }

    transitions: Transition {
        ColorAnimation { duration: Common.Appearance.animDurationFast }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onClicked: mouse => { mouse.accepted = false }
        onPressed: mouse => { mouse.accepted = false }
        onReleased: mouse => { mouse.accepted = false }
    }
}
