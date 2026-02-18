import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../common" as Common

// ━━━ 系统更新指示 ━━━
Rectangle {
    id: root

    color: Common.Appearance.surfaceBright
    Layout.fillHeight: true
    implicitWidth: updatesRow.implicitWidth + Common.Appearance.itemPadding * 2

    property int updateCount: 0

    RowLayout {
        id: updatesRow
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: root.updateCount > 0 ? " " : ""
            color: Common.Appearance.error
            font.family: Common.Appearance.font.family
            font.pixelSize: Common.Appearance.font.sizeNormal
            visible: root.updateCount > 0
        }

        Text {
            text: root.updateCount > 0 ? root.updateCount.toString() : ""
            color: Common.Appearance.error
            font.family: Common.Appearance.font.family
            font.pixelSize: Common.Appearance.font.sizeNormal
            visible: root.updateCount > 0
        }
    }

    Timer {
        interval: 600000  // 10 分钟
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: updateProc.running = true
    }

    Process {
        id: updateProc
        command: ["bash", "-c", "checkupdates 2>/dev/null | wc -l"]
        stdout: SplitParser {
            onRead: data => { root.updateCount = parseInt(data) || 0 }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: root.updateCount > 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            if (root.updateCount > 0)
                Quickshell.execDetached("kitty -e paru")
        }
    }
}
