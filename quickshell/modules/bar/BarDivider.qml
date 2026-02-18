import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

import "../common" as Common

// ━━━ 斜切分隔符 (模拟 waybar powerline 效果) ━━━
// 通过半圆弧实现左右颜色过渡
Item {
    id: root

    property color leftColor: "transparent"
    property color rightColor: "transparent"

    Layout.fillHeight: true
    implicitWidth: Common.Appearance.barHeight / 2

    // 左半部分
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 2
        color: leftColor
    }

    // 右半部分
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 2
        color: rightColor
    }

    // 半圆弧 (左色覆盖在右色上)
    Shape {
        anchors.fill: parent
        ShapePath {
            fillColor: leftColor
            strokeColor: "transparent"
            startX: 0; startY: 0
            PathArc {
                x: 0; y: root.height
                radiusX: root.width
                radiusY: root.height / 2
                direction: PathArc.Clockwise
            }
            PathLine { x: 0; y: 0 }
        }
    }
}
