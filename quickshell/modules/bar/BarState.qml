pragma Singleton

import QtQuick

// Bar 全局状态
QtObject {
    property bool visible: true

    // 面板开关 (QuickSettings / Calendar)
    property bool quickSettingsOpen: false
    property bool calendarOpen: false

    // 互斥：打开一个关闭另一个
    function toggleQuickSettings() {
        calendarOpen = false
        quickSettingsOpen = !quickSettingsOpen
    }

    function toggleCalendar() {
        quickSettingsOpen = false
        calendarOpen = !calendarOpen
    }

    function closeAll() {
        quickSettingsOpen = false
        calendarOpen = false
    }
}
