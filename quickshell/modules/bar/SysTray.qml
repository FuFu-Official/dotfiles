import QtQuick
import Quickshell.Services.SystemTray

import "../common" as Common

// ━━━ 系统托盘 ━━━
Item {
    id: root

    implicitWidth: trayRow.implicitWidth
    height: parent ? parent.height : Common.Appearance.barHeight
    visible: trayRepeater.count > 0

    Row {
        id: trayRow
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            id: trayRepeater
            model: SystemTray.items

            Image {
                id: trayIcon

                required property SystemTrayItem modelData

                source: modelData.icon ?? ""
                sourceSize.width: 18
                sourceSize.height: 18
                width: 18; height: 18
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton)
                            trayIcon.modelData.activate()
                        else
                            trayIcon.modelData.secondaryActivate()
                    }
                }
            }
        }
    }
}
