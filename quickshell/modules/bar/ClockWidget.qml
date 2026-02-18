import QtQuick
import QtQuick.Controls as QC
import Quickshell

import "../common" as Common

// ━━━ 时钟 ━━━
Item {
    id: root

    implicitWidth: timeText.implicitWidth + 4
    height: parent ? parent.height : Common.Appearance.barHeight

    Text {
        id: timeText
        anchors.centerIn: parent
        text: Qt.formatTime(new Date(), "HH:mm")
        color: Common.Appearance.surfaceFg
        font.family: Common.Appearance.font.family
        font.pixelSize: Common.Appearance.font.sizeLarge
        font.bold: true
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: timeText.text = Qt.formatTime(new Date(), "HH:mm")
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached("walker")

        QC.ToolTip {
            id: clockTip
            visible: parent.containsMouse
            text: Qt.formatDate(new Date(), "yyyy/MM/dd dddd")
            delay: 300

            background: Rectangle {
                color: Common.Appearance.surfaceContainerHigh
                border.width: 0
                radius: 8
            }

            contentItem: Text {
                color: Common.Appearance.surfaceFg
                font.family: Common.Appearance.font.family
                font.pixelSize: Common.Appearance.font.sizeSmall
                text: clockTip.text
            }
        }
    }
}
