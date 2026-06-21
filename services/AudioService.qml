pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire

QtObject {
    id: root

    readonly property var sink: Pipewire.ready ? Pipewire.defaultAudioSink : null
    
    readonly property real volume: sink ? Math.round(sink.audio.volume * 100) : 0
    readonly property bool isMuted: sink ? sink.audio.muted : true

    function getIcon() {
        if (isMuted || volume === 0) return "audio-volume-muted-symbolic";
        if (volume <= 33) return "audio-volume-low-symbolic";
        if (volume <= 66) return "audio-volume-medium-symbolic";
        return "audio-volume-high-symbolic";
    }

    readonly property string icon: getIcon()
    
    function toggleMute() {
        if (sink) sink.audio.muted = !sink.audio.muted;
    }
    
    function setVolume(v) {
        if (sink) sink.audio.volume = Math.max(0, Math.min(1, v / 100.0));
    }
}
