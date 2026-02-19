import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "../common" as Common
import "../bar" as Bar

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 快捷设置面板 - 从栏顶右侧弹出
// QuickShell 独有优势：原生弹出面板，无需外部工具
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Scope {
    id: qsRoot

    readonly property bool isOpen: Bar.BarState.quickSettingsOpen

    // ── 点击外部关闭（背景遮罩） ──
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData
            visible: qsRoot.isOpen

            color: Qt.rgba(0, 0, 0, 0.15)

            WlrLayershell.namespace: "quickshell:qs-backdrop"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            anchors { top: true; left: true; right: true; bottom: true }
            exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            focusable: true

            MouseArea {
                anchors.fill: parent
                onClicked: Bar.BarState.closeAll()
            }
        }
    }

    // ── 面板窗口 ──
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWindow

            property var modelData
            screen: modelData
            visible: qsRoot.isOpen && (Hyprland.monitorFor(modelData)?.focused ?? false)

            color: "transparent"

            implicitWidth: 380
            implicitHeight: panelContent.implicitHeight + 24

            WlrLayershell.namespace: "quickshell:quick-settings"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.margins.top: Common.Appearance.barHeight + Common.Appearance.barMargin * 2
            WlrLayershell.margins.right: Common.Appearance.barMargin

            anchors { top: true; right: true }
            exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            focusable: true

            // ── 面板卡片 ──
            Rectangle {
                id: panelCard
                anchors.fill: parent
                anchors.margins: 4
                radius: 20
                color: Common.Appearance.surfaceContainer
                clip: true

                // 进入/退出动画
                opacity: qsRoot.isOpen ? 1 : 0
                scale: qsRoot.isOpen ? 1 : 0.9
                transformOrigin: Item.TopRight

                Behavior on opacity {
                    NumberAnimation { duration: Common.Appearance.animDuration; easing.type: Easing.OutCubic }
                }
                Behavior on scale {
                    NumberAnimation { duration: Common.Appearance.animDuration; easing.type: Easing.OutCubic }
                }

                ColumnLayout {
                    id: panelContent
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 14

                    // ═══════════════════════════
                    // 音量控制
                    // ═══════════════════════════
                    QsSliderRow {
                        icon: audioService?.volumeIcon ?? ""
                        label: "Volume"
                        value: (audioService?.volume ?? 0.5) * 100
                        accentColor: Common.Appearance.primary
                        muted: audioService?.muted ?? false

                        onValueAdjusted: newVal => {
                            if (audioService) audioService.setVolume(newVal / 100)
                        }
                        onIconClicked: {
                            if (audioService) audioService.toggleMute()
                        }
                    }

                    // ═══════════════════════════
                    // 亮度控制
                    // ═══════════════════════════
                    QsSliderRow {
                        icon: brightnessService?.icon ?? "󰃟"
                        label: "Brightness"
                        value: brightnessService?.percentInt ?? 100
                        accentColor: Common.Appearance.tertiary

                        onValueAdjusted: newVal => {
                            const pct = Math.round(newVal)
                            Quickshell.execDetached("brightnessctl set " + pct + "%")
                        }
                    }

                    // ── 分隔线 ──
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Common.Appearance.outlineVariant
                        opacity: 0.5
                    }

                    // ═══════════════════════════
                    // 快捷开关行
                    // ═══════════════════════════
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        // 网络
                        QsToggleButton {
                            icon: networkService?.icon ?? "󰤮"
                            label: "Network"
                            active: networkService?.connected ?? false
                            accentColor: Common.Appearance.primary
                            onToggled: Quickshell.execDetached("kitty --class nmtui -e nmtui")
                        }

                        // 蓝牙
                        QsToggleButton {
                            icon: bluetoothService?.icon ?? "󰂯"
                            label: "Bluetooth"
                            active: bluetoothService?.powered ?? false
                            accentColor: Common.Appearance.secondary
                            onToggled: Quickshell.execDetached("bluetoothctl power toggle")
                        }

                        // Idle 抑制
                        QsToggleButton {
                            id: idleBtn
                            icon: idleBtn.active ? "" : ""
                            label: "Caffeine"
                            active: false
                            accentColor: Common.Appearance.tertiary
                            onToggled: {
                                idleBtn.active = !idleBtn.active
                                if (idleBtn.active)
                                    Quickshell.execDetached("systemctl --user stop hypridle.service")
                                else
                                    Quickshell.execDetached("systemctl --user start hypridle.service")
                            }
                        }
                    }

                    // ── 分隔线 ──
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Common.Appearance.outlineVariant
                        opacity: 0.5
                        visible: mediaSection.visible
                    }

                    // ═══════════════════════════
                    // 媒体播放器
                    // ═══════════════════════════
                    ColumnLayout {
                        id: mediaSection
                        Layout.fillWidth: true
                        spacing: 10
                        visible: mediaService?.hasPlayer ?? false

                        // 专辑封面 + 信息
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            // 封面
                            Rectangle {
                                width: 56; height: 56
                                radius: 12
                                color: Common.Appearance.surfaceContainerHighest
                                clip: true

                                Image {
                                    anchors.fill: parent
                                    source: mediaService?.artUrl ?? ""
                                    fillMode: Image.PreserveAspectCrop
                                    visible: source.toString() !== ""
                                }

                                // 无封面占位
                                Text {
                                    anchors.centerIn: parent
                                    text: "󰎆"
                                    color: Common.Appearance.surfaceVariantFg
                                    font.family: Common.Appearance.font.family
                                    font.pixelSize: 24
                                    visible: (mediaService?.artUrl ?? "") === ""
                                }
                            }

                            // 标题 + 艺术家
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    Layout.fillWidth: true
                                    text: mediaService?.title ?? ""
                                    color: Common.Appearance.surfaceFg
                                    font.family: Common.Appearance.font.family
                                    font.pixelSize: Common.Appearance.font.sizeNormal
                                    font.bold: true
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: mediaService?.artist ?? ""
                                    color: Common.Appearance.surfaceVariantFg
                                    font.family: Common.Appearance.font.family
                                    font.pixelSize: Common.Appearance.font.sizeSmall
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                }

                                Text {
                                    text: mediaService?.identity ?? ""
                                    color: Common.Appearance.outline
                                    font.family: Common.Appearance.font.family
                                    font.pixelSize: 10
                                }
                            }
                        }

                        // 播放控件
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 20

                            // Shuffle
                            Text {
                                text: "󰒟"
                                color: (mediaService?.shuffle ?? false)
                                       ? Common.Appearance.primary
                                       : Common.Appearance.surfaceVariantFg
                                font.family: Common.Appearance.font.family
                                font.pixelSize: 18

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { if (mediaService) mediaService.toggleShuffle() }
                                }
                            }

                            // 上一曲
                            Text {
                                text: "󰒮"
                                color: (mediaService?.canPrev ?? false)
                                       ? Common.Appearance.surfaceFg
                                       : Common.Appearance.surfaceVariantFg
                                font.family: Common.Appearance.font.family
                                font.pixelSize: 22

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { if (mediaService) mediaService.previous() }
                                }
                            }

                            // 播放/暂停
                            Rectangle {
                                width: 42; height: 42
                                radius: 21
                                color: Common.Appearance.primary

                                Text {
                                    anchors.centerIn: parent
                                    text: mediaService?.playIcon ?? "󰐊"
                                    color: Common.Appearance.primaryFg
                                    font.family: Common.Appearance.font.family
                                    font.pixelSize: 22
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { if (mediaService) mediaService.togglePlaying() }
                                }
                            }

                            // 下一曲
                            Text {
                                text: "󰒭"
                                color: (mediaService?.canNext ?? false)
                                       ? Common.Appearance.surfaceFg
                                       : Common.Appearance.surfaceVariantFg
                                font.family: Common.Appearance.font.family
                                font.pixelSize: 22

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { if (mediaService) mediaService.next() }
                                }
                            }

                            // 循环
                            Text {
                                text: (mediaService?.loopState ?? 0) === 2 ? "󰑘" : "󰑖"
                                color: (mediaService?.loopState ?? 0) !== 0
                                       ? Common.Appearance.primary
                                       : Common.Appearance.surfaceVariantFg
                                font.family: Common.Appearance.font.family
                                font.pixelSize: 18

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { if (mediaService) mediaService.cycleLoop() }
                                }
                            }
                        }
                    }

                    // ── 底部空间 ──
                    Item { Layout.fillHeight: true; Layout.minimumHeight: 2 }
                }
            }
        }
    }

    // ═════════════════════════════════════════════
    // 内联组件：滑块行
    // ═════════════════════════════════════════════
    component QsSliderRow: RowLayout {
        id: sliderRow

        property string icon: ""
        property string label: ""
        property real value: 50    // 0–100
        property color accentColor: Common.Appearance.primary
        property bool muted: false

        signal valueAdjusted(real newVal)
        signal iconClicked()

        Layout.fillWidth: true
        spacing: 12

        // 图标按钮
        Rectangle {
            width: 38; height: 38
            radius: 19
            color: sliderRow.muted
                   ? Common.Appearance.surfaceVariant
                   : Common.Appearance.transparentize(sliderRow.accentColor, 0.2)

            Text {
                anchors.centerIn: parent
                text: sliderRow.icon
                color: sliderRow.muted
                       ? Common.Appearance.surfaceVariantFg
                       : sliderRow.accentColor
                font.family: Common.Appearance.font.family
                font.pixelSize: Common.Appearance.font.sizeIcon
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: sliderRow.iconClicked()
            }
        }

        // 滑块区域
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            // 标签 + 数值
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: sliderRow.label
                    color: Common.Appearance.surfaceFg
                    font.family: Common.Appearance.font.family
                    font.pixelSize: Common.Appearance.font.sizeSmall
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: Math.round(sliderRow.value) + "%"
                    color: Common.Appearance.surfaceVariantFg
                    font.family: Common.Appearance.font.family
                    font.pixelSize: Common.Appearance.font.sizeSmall
                }
            }

            // 自定义滑块
            Item {
                Layout.fillWidth: true
                height: 24

                // 轨道背景
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 6
                    radius: 3
                    color: Common.Appearance.surfaceVariant

                    // 填充
                    Rectangle {
                        width: Math.max(6, parent.width * (sliderRow.value / 100))
                        height: parent.height
                        radius: 3
                        color: sliderRow.muted
                               ? Common.Appearance.surfaceVariantFg
                               : sliderRow.accentColor

                        Behavior on width {
                            NumberAnimation { duration: 50 }
                        }
                    }
                }

                // 拖拽手柄
                Rectangle {
                    id: handle
                    x: Math.max(0, Math.min(parent.width - width, (parent.width - width) * (sliderRow.value / 100)))
                    anchors.verticalCenter: parent.verticalCenter
                    width: 18; height: 18
                    radius: 9
                    color: sliderRow.accentColor
                    visible: sliderDrag.containsMouse || sliderDrag.pressed

                    Behavior on x {
                        enabled: !sliderDrag.pressed
                        NumberAnimation { duration: 50 }
                    }
                }

                MouseArea {
                    id: sliderDrag
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onPressed: mouse => {
                        updateValue(mouse.x)
                    }
                    onPositionChanged: mouse => {
                        if (pressed) updateValue(mouse.x)
                    }

                    function updateValue(mouseX) {
                        const clamped = Math.max(0, Math.min(100, (mouseX / width) * 100))
                        sliderRow.valueAdjusted(clamped)
                    }
                }
            }
        }
    }

    // ═════════════════════════════════════════════
    // 内联组件：快捷开关按钮
    // ═════════════════════════════════════════════
    component QsToggleButton: Rectangle {
        id: toggleBtn

        property string icon: ""
        property string label: ""
        property bool active: false
        property color accentColor: Common.Appearance.primary

        signal toggled()

        Layout.fillWidth: true
        height: 72
        radius: 16
        color: toggleBtn.active
               ? Common.Appearance.transparentize(toggleBtn.accentColor, 0.2)
               : Common.Appearance.surfaceContainerHigh

        Column {
            anchors.centerIn: parent
            spacing: 4

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: toggleBtn.icon
                color: toggleBtn.active ? toggleBtn.accentColor : Common.Appearance.surfaceVariantFg
                font.family: Common.Appearance.font.family
                font.pixelSize: 22
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: toggleBtn.label
                color: toggleBtn.active ? Common.Appearance.surfaceFg : Common.Appearance.surfaceVariantFg
                font.family: Common.Appearance.font.family
                font.pixelSize: 10
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: toggleBtn.toggled()
        }

        Behavior on color {
            ColorAnimation { duration: Common.Appearance.animDurationFast }
        }
    }
}
