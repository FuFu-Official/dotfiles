pragma Singleton

import QtQuick

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Material Design 3 色彩系统
// 颜色来自 Matugen 生成，与你的 waybar colors.css 一致
// 如果使用 Matugen 动态主题，可改为读取 colors.json
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QtObject {
    id: root

    // ── 主色 ──
    readonly property color primary: "#c7bfff"
    readonly property color primaryFg: "#2f295f"
    readonly property color primaryContainer: "#463f77"
    readonly property color primaryContainerFg: "#e4dfff"

    // ── 二级色 ──
    readonly property color secondary: "#c8c3dc"
    readonly property color secondaryFg: "#302e41"
    readonly property color secondaryContainer: "#474459"
    readonly property color secondaryContainerFg: "#e5dff9"

    // ── 三级色 ──
    readonly property color tertiary: "#ecb8ce"
    readonly property color tertiaryFg: "#482537"
    readonly property color tertiaryContainer: "#613b4d"
    readonly property color tertiaryContainerFg: "#ffd8e8"

    // ── 错误色 ──
    readonly property color error: "#ffb4ab"
    readonly property color errorFg: "#690005"
    readonly property color errorContainer: "#93000a"
    readonly property color errorContainerFg: "#ffdad6"

    // ── 表面色 (背景层级) ──
    readonly property color background: "#141318"
    readonly property color backgroundFg: "#e5e1e9"
    readonly property color surface: "#141318"
    readonly property color surfaceFg: "#e5e1e9"
    readonly property color surfaceDim: "#141318"
    readonly property color surfaceBright: "#3a383e"
    readonly property color surfaceContainer: "#201f25"
    readonly property color surfaceContainerLow: "#1c1b20"
    readonly property color surfaceContainerHigh: "#2a292f"
    readonly property color surfaceContainerHighest: "#35343a"
    readonly property color surfaceContainerLowest: "#0e0e13"
    readonly property color surfaceVariant: "#47464f"
    readonly property color surfaceVariantFg: "#c9c5d0"

    // ── 轮廓 ──
    readonly property color outline: "#928f99"
    readonly property color outlineVariant: "#47464f"

    // ── 反色 ──
    readonly property color inverseSurface: "#e5e1e9"
    readonly property color inverseSurfaceFg: "#313036"
    readonly property color inversePrimary: "#5e5791"

    // ━━━ 字体配置 ━━━
    readonly property QtObject font: QtObject {
        readonly property string family: "JetBrainsMono Nerd Font Propo"
        readonly property string familyCjk: "LXGW WenKai Screen"
        readonly property string familyAll: "JetBrainsMono Nerd Font Propo, LXGW WenKai Screen"
        readonly property int sizeSmall: 12
        readonly property int sizeNormal: 14
        readonly property int sizeLarge: 16
        readonly property int sizeXLarge: 20
        readonly property int sizeHuge: 24
        readonly property int sizeIcon: 18
    }

    // ━━━ 尺寸配置 ━━━
    readonly property int barHeight: 44
    readonly property int barMargin: 8
    readonly property int groupRadius: 22
    readonly property int groupGap: 8
    readonly property int groupPadding: 12
    readonly property int itemSpacing: 6
    readonly property int itemPadding: 8

    // ━━━ 动画配置 ━━━
    readonly property int animDuration: 200
    readonly property int animDurationFast: 100
    readonly property int animDurationSlow: 350

    // ━━━ 辅助函数 ━━━
    function transparentize(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }
}
