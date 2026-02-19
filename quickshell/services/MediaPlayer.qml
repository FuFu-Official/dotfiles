import QtQuick
import Quickshell.Services.Mpris

// ━━━ 媒体播放器服务 (MPRIS 原生) ━━━
// QuickShell 独有优势：原生 MPRIS 绑定，无需 playerctl
Item {
    id: root
    visible: false

    // 所有播放器
    readonly property var playerList: Mpris.players.values

    // 活跃播放器：优先选择正在播放的
    readonly property var activePlayer: {
        let playing = null
        let first = null
        for (const p of Mpris.players.values) {
            if (!first) first = p
            if (p.isPlaying) { playing = p; break }
        }
        return playing || first || null
    }

    // ── 常用属性 ──
    readonly property bool hasPlayer: activePlayer !== null
    readonly property bool isPlaying: activePlayer?.isPlaying ?? false
    readonly property string title: activePlayer?.trackTitle ?? ""
    readonly property string artist: activePlayer?.trackArtist ?? ""
    readonly property string album: activePlayer?.trackAlbum ?? ""
    readonly property string artUrl: activePlayer?.trackArtUrl ?? ""
    readonly property string identity: activePlayer?.identity ?? ""
    readonly property real position: activePlayer?.position ?? 0
    readonly property real length: activePlayer?.length ?? 0
    readonly property bool canNext: activePlayer?.canGoNext ?? false
    readonly property bool canPrev: activePlayer?.canGoPrevious ?? false
    readonly property bool canToggle: activePlayer?.canTogglePlaying ?? false
    readonly property bool shuffle: activePlayer?.shuffle ?? false
    readonly property int loopState: activePlayer?.loopState ?? MprisLoopState.None

    // ── 播放图标 ──
    readonly property string playIcon: isPlaying ? "󰏤" : "󰐊"

    // ── 控制函数 ──
    function togglePlaying() { if (activePlayer) activePlayer.togglePlaying() }
    function next() { if (activePlayer?.canGoNext) activePlayer.next() }
    function previous() { if (activePlayer?.canGoPrevious) activePlayer.previous() }
    function toggleShuffle() { if (activePlayer) activePlayer.shuffle = !activePlayer.shuffle }
    function cycleLoop() {
        if (!activePlayer) return
        if (activePlayer.loopState === MprisLoopState.None)
            activePlayer.loopState = MprisLoopState.Playlist
        else if (activePlayer.loopState === MprisLoopState.Playlist)
            activePlayer.loopState = MprisLoopState.Track
        else
            activePlayer.loopState = MprisLoopState.None
    }

    // 格式化时间 mm:ss
    function formatTime(seconds) {
        if (seconds <= 0) return "0:00"
        const m = Math.floor(seconds / 60)
        const s = Math.floor(seconds % 60)
        return m + ":" + (s < 10 ? "0" : "") + s
    }
}
