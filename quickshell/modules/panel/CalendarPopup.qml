import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "../common" as Common
import "../bar" as Bar

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 日历弹出面板 - 从时钟弹出
// QuickShell 独有优势：纯 QML 日历组件，原生动画
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Scope {
    id: calRoot

    readonly property bool isOpen: Bar.BarState.calendarOpen

    // ── 日历数据 ──
    property int displayYear: new Date().getFullYear()
    property int displayMonth: new Date().getMonth()  // 0-based

    readonly property var today: new Date()
    readonly property int todayDay: today.getDate()
    readonly property int todayMonth: today.getMonth()
    readonly property int todayYear: today.getFullYear()

    // ── 月份名称 ──
    readonly property var monthNames: [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]

    // ── 星期名称 ──
    readonly property var dayNames: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    // ── 计算日历格子 ──
    function getDaysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate()
    }

    function getFirstDayOfWeek(year, month) {
        // 0=Sunday, convert to Monday-first: (day + 6) % 7
        const d = new Date(year, month, 1).getDay()
        return (d + 6) % 7
    }

    function getCalendarDays() {
        const days = []
        const daysInMonth = getDaysInMonth(displayYear, displayMonth)
        const firstDay = getFirstDayOfWeek(displayYear, displayMonth)

        // 上月填充
        const prevMonth = displayMonth === 0 ? 11 : displayMonth - 1
        const prevYear = displayMonth === 0 ? displayYear - 1 : displayYear
        const prevDays = getDaysInMonth(prevYear, prevMonth)
        for (let i = firstDay - 1; i >= 0; i--) {
            days.push({ day: prevDays - i, current: false, isToday: false })
        }

        // 当月
        for (let d = 1; d <= daysInMonth; d++) {
            const isToday = d === todayDay && displayMonth === todayMonth && displayYear === todayYear
            days.push({ day: d, current: true, isToday: isToday })
        }

        // 下月填充 (补到 42 格 = 6 行)
        const remaining = 42 - days.length
        for (let d = 1; d <= remaining; d++) {
            days.push({ day: d, current: false, isToday: false })
        }

        return days
    }

    function prevMonth() {
        if (displayMonth === 0) {
            displayMonth = 11
            displayYear--
        } else {
            displayMonth--
        }
    }

    function nextMonth() {
        if (displayMonth === 11) {
            displayMonth = 0
            displayYear++
        } else {
            displayMonth++
        }
    }

    function goToday() {
        displayYear = todayYear
        displayMonth = todayMonth
    }

    // ── 重置到当月（关闭时重置） ──
    onIsOpenChanged: {
        if (isOpen) goToday()
    }

    // ── 点击外部关闭 ──
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData
            visible: calRoot.isOpen

            color: Qt.rgba(0, 0, 0, 0.1)

            WlrLayershell.namespace: "quickshell:cal-backdrop"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            anchors { top: true; left: true; right: true; bottom: true }
            exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            focusable: false

            MouseArea {
                anchors.fill: parent
                onClicked: Bar.BarState.closeAll()
            }
        }
    }

    // ── 日历面板窗口 ──
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: calWindow

            property var modelData
            screen: modelData
            visible: calRoot.isOpen && (Hyprland.monitorFor(modelData)?.focused ?? false)

            color: "transparent"

            implicitWidth: 340
            implicitHeight: calContent.implicitHeight + 32

            WlrLayershell.namespace: "quickshell:calendar"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            anchors { top: true; left: true; right: true }
            exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            focusable: true

            // ── 日历卡片 ──
            Rectangle {
                id: calCard
                width: 340
                height: calContent.implicitHeight + 32
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Common.Appearance.barHeight + Common.Appearance.barMargin * 2
                radius: 20
                color: Common.Appearance.surfaceContainer

                opacity: calRoot.isOpen ? 1 : 0
                scale: calRoot.isOpen ? 1 : 0.9
                transformOrigin: Item.Top

                Behavior on opacity {
                    NumberAnimation { duration: Common.Appearance.animDuration; easing.type: Easing.OutCubic }
                }
                Behavior on scale {
                    NumberAnimation { duration: Common.Appearance.animDuration; easing.type: Easing.OutCubic }
                }

                ColumnLayout {
                    id: calContent
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    // ── 当前时间（大字） ──
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatTime(calRoot.today, "HH:mm")
                        color: Common.Appearance.primary
                        font.family: Common.Appearance.font.family
                        font.pixelSize: 42
                        font.bold: true
                    }

                    // ── 日期行 ──
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDate(calRoot.today, "yyyy年M月d日 dddd")
                        color: Common.Appearance.surfaceVariantFg
                        font.family: Common.Appearance.font.familyCjk
                        font.pixelSize: Common.Appearance.font.sizeNormal
                    }

                    // ── 分隔线 ──
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Common.Appearance.outlineVariant
                        opacity: 0.5
                    }

                    // ── 月份导航 ──
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "󰅁"
                            color: Common.Appearance.surfaceFg
                            font.family: Common.Appearance.font.family
                            font.pixelSize: 18
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: calRoot.prevMonth()
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: calRoot.monthNames[calRoot.displayMonth] + " " + calRoot.displayYear
                            color: Common.Appearance.surfaceFg
                            font.family: Common.Appearance.font.family
                            font.pixelSize: Common.Appearance.font.sizeNormal
                            font.bold: true

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: calRoot.goToday()
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "󰅂"
                            color: Common.Appearance.surfaceFg
                            font.family: Common.Appearance.font.family
                            font.pixelSize: 18
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: calRoot.nextMonth()
                            }
                        }
                    }

                    // ── 星期标题 ──
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 7
                        rowSpacing: 0
                        columnSpacing: 0

                        Repeater {
                            model: calRoot.dayNames

                            Text {
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                                text: modelData
                                color: Common.Appearance.outline
                                font.family: Common.Appearance.font.family
                                font.pixelSize: 11
                                font.bold: true
                            }
                        }
                    }

                    // ── 日历网格 ──
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 7
                        rowSpacing: 4
                        columnSpacing: 4

                        Repeater {
                            model: calRoot.getCalendarDays()

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 36
                                radius: 18
                                color: modelData.isToday
                                       ? Common.Appearance.primary
                                       : dayHover.containsMouse && modelData.current
                                         ? Common.Appearance.surfaceContainerHigh
                                         : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.day
                                    color: {
                                        if (modelData.isToday) return Common.Appearance.primaryFg
                                        if (!modelData.current) return Common.Appearance.outline
                                        return Common.Appearance.surfaceFg
                                    }
                                    font.family: Common.Appearance.font.family
                                    font.pixelSize: Common.Appearance.font.sizeSmall
                                    font.bold: modelData.isToday
                                }

                                MouseArea {
                                    id: dayHover
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: modelData.current ? Qt.PointingHandCursor : Qt.ArrowCursor
                                }

                                Behavior on color {
                                    ColorAnimation { duration: Common.Appearance.animDurationFast }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
