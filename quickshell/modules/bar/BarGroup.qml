import QtQuick
import QtQuick.Layouts

import "../common" as Common

// ━━━ 圆角分组容器 (pill) ━━━
// 用法: BarGroup { NetworkWidget {}; AudioWidget {} }
// 子项自动排入内部 Row
Rectangle {
    id: root

    default property alias contentData: contentRow.data
    property color bgColor: Common.Appearance.surfaceContainer

    color: bgColor
    radius: Common.Appearance.groupRadius
    Layout.fillHeight: true
    implicitWidth: contentRow.implicitWidth + Common.Appearance.groupPadding * 2

    Row {
        id: contentRow
        x: Common.Appearance.groupPadding
        height: parent.height
        spacing: Common.Appearance.itemSpacing
    }
}
