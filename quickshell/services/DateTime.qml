import QtQuick
import Quickshell
import Quickshell.Io

// ━━━ 时间日期服务 ━━━
Item {
    id: root

    readonly property alias time: timeText.text
    readonly property alias date: dateText.text
    readonly property alias longDate: longDateText.text
    readonly property alias dayOfWeek: dayOfWeekText.text

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // 格式化输出
    Text { id: timeText; visible: false; text: Qt.formatTime(clock.date, "HH:mm") }
    Text { id: dateText; visible: false; text: Qt.formatDate(clock.date, "yyyy/MM/dd") }
    Text { id: longDateText; visible: false; text: Qt.formatDate(clock.date, "yyyy年M月d日") }
    Text { id: dayOfWeekText; visible: false; text: Qt.formatDate(clock.date, "dddd") }
}
