import QtQuick

import "../common" as Common

// ━━━ 媒体播放器 Bar Widget ━━━
// 当有音乐播放时在 bar 左侧显示
// 点击弹出 Quick Settings 面板查看完整控件
Item {
    id: root

    visible: mediaService?.hasPlayer ?? false
    implicitWidth: visible ? mediaRow.implicitWidth + 8 : 0
    height: parent ? parent.height : Common.Appearance.barHeight

    Row {
        id: mediaRow
        anchors.centerIn: parent
        spacing: 8

        // 播放/暂停按钮
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: mediaService?.playIcon ?? "󰐊"
            color: Common.Appearance.primary
            font.family: Common.Appearance.font.family
            font.pixelSize: Common.Appearance.font.sizeIcon

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: { if (mediaService) mediaService.togglePlaying() }
            }
        }

        // 歌曲信息（滚动）
        Item {
            width: Math.min(mediaLabel.implicitWidth, 160)
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            clip: true

            Text {
                id: mediaLabel
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    const t = mediaService?.title ?? ""
                    const a = mediaService?.artist ?? ""
                    if (a && t) return a + " · " + t
                    return t || a || ""
                }
                color: Common.Appearance.surfaceFg
                font.family: Common.Appearance.font.family
                font.pixelSize: Common.Appearance.font.sizeSmall
                opacity: 0.9
            }

            // 文字过长时滚动
            NumberAnimation on x {
                id: scrollAnim
                running: mediaLabel.implicitWidth > 160
                from: 0
                to: -(mediaLabel.implicitWidth - 140)
                duration: Math.max(3000, (mediaLabel.implicitWidth - 140) * 40)
                loops: Animation.Infinite
                easing.type: Easing.Linear
            }
        }
    }

    // 滚轮切歌
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        acceptedButtons: Qt.NoButton
        onWheel: event => {
            if (!mediaService) return
            if (event.angleDelta.y > 0) mediaService.previous()
            else mediaService.next()
        }
    }
}
