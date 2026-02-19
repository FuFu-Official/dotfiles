import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

import "../common" as Common

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// OSD 浮动提示 - Volume / Brightness 调节时显示
// QuickShell 独有优势：原生 overlay 层，流畅动画，无需 swayosd
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Scope {
    id: osdRoot

    // ── 对外属性 (由 shell.qml 绑定) ──
    property real currentVolume: 0        // 0–1
    property bool currentMuted: false
    property int currentBrightness: 0     // 0–100
    property string volumeIcon: ""
    property string brightnessIcon: "󰃟"

    // ── 内部状态 ──
    property string osdType: "volume"     // "volume" | "brightness"
    property real osdValue: 0             // 0–100
    property string osdIcon: ""
    property bool osdVisible: false

    // ── 避免初始化时触发 ──
    property bool initialized: false
    Component.onCompleted: Qt.callLater(() => { initialized = true })

    // ── 监听音量变化 ──
    onCurrentVolumeChanged: {
        if (!initialized) return
        showOsd("volume", Math.round(currentVolume * 100), volumeIcon)
    }
    onCurrentMutedChanged: {
        if (!initialized) return
        showOsd("volume", Math.round(currentVolume * 100), currentMuted ? "󰝟" : volumeIcon)
    }

    // ── 监听亮度变化 ──
    onCurrentBrightnessChanged: {
        if (!initialized) return
        showOsd("brightness", currentBrightness, brightnessIcon)
    }

    function showOsd(type, value, icon) {
        osdType = type
        osdValue = Math.max(0, Math.min(100, value))
        osdIcon = icon
        osdVisible = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: osdVisible = false
    }

    // ── OSD 窗口 (每个屏幕一个，只在焦点屏幕显示) ──
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: osdWindow

            property var modelData

            screen: modelData
            visible: osdRoot.osdVisible
            color: "transparent"

            implicitWidth: 200
            implicitHeight: 160

            WlrLayershell.namespace: "quickshell:osd"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            anchors {
                bottom: true
                left: true
                right: true
            }

            exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            focusable: false

            // 内容居中
            Item {
                anchors.fill: parent

                // OSD 卡片
                Rectangle {
                    id: osdCard
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 120
                    width: 180
                    height: 140
                    radius: 24
                    color: Common.Appearance.transparentize(Common.Appearance.surfaceContainerHigh, 0.92)

                    opacity: osdRoot.osdVisible ? 1 : 0
                    scale: osdRoot.osdVisible ? 1 : 0.8

                    Behavior on opacity {
                        NumberAnimation { duration: Common.Appearance.animDuration; easing.type: Easing.OutCubic }
                    }
                    Behavior on scale {
                        NumberAnimation { duration: Common.Appearance.animDuration; easing.type: Easing.OutCubic }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 12

                        // 图标
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: osdRoot.osdIcon
                            color: osdRoot.osdType === "volume"
                                   ? Common.Appearance.primary
                                   : Common.Appearance.tertiary
                            font.family: Common.Appearance.font.family
                            font.pixelSize: 36
                        }

                        // 进度条
                        Item {
                            width: 140
                            height: 6
                            anchors.horizontalCenter: parent.horizontalCenter

                            // 背景轨道
                            Rectangle {
                                anchors.fill: parent
                                radius: 3
                                color: Common.Appearance.surfaceVariant
                            }

                            // 填充
                            Rectangle {
                                width: parent.width * (osdRoot.osdValue / 100)
                                height: parent.height
                                radius: 3
                                color: osdRoot.osdType === "volume"
                                       ? Common.Appearance.primary
                                       : Common.Appearance.tertiary

                                Behavior on width {
                                    NumberAnimation { duration: Common.Appearance.animDurationFast; easing.type: Easing.OutCubic }
                                }
                            }
                        }

                        // 百分比文字
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: Math.round(osdRoot.osdValue) + "%"
                            color: Common.Appearance.surfaceFg
                            font.family: Common.Appearance.font.family
                            font.pixelSize: Common.Appearance.font.sizeLarge
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}
