import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// ━━━ 音频服务 (PipeWire) ━━━
Item {
    id: root

    readonly property PwNode defaultSink: Pipewire.defaultAudioSink
    readonly property PwNode defaultSource: Pipewire.defaultAudioSource

    readonly property real volume: defaultSink?.audio?.volume ?? 0
    readonly property bool muted: defaultSink?.audio?.muted ?? false
    readonly property real micVolume: defaultSource?.audio?.volume ?? 0
    readonly property bool micMuted: defaultSource?.audio?.muted ?? true

    // 音量百分比 (0–100)
    readonly property int volumePercent: Math.round(volume * 100)
    readonly property int micVolumePercent: Math.round(micVolume * 100)

    // 音量图标
    readonly property string volumeIcon: {
        if (muted || volume <= 0) return "󰝟"
        if (volume < 0.33) return ""
        if (volume < 0.66) return ""
        return ""
    }

    readonly property string micIcon: micMuted ? "" : ""

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    function setVolume(val) {
        if (defaultSink?.audio) defaultSink.audio.volume = Math.max(0, Math.min(1.0, val))
    }
    function toggleMute() {
        if (defaultSink?.audio) defaultSink.audio.muted = !defaultSink.audio.muted
    }
    function toggleMicMute() {
        if (defaultSource?.audio) defaultSource.audio.muted = !defaultSource.audio.muted
    }
    function increaseVolume() { setVolume(volume + 0.05) }
    function decreaseVolume() { setVolume(volume - 0.05) }
}
