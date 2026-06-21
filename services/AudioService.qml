pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property real volume: 0
    property bool isMuted: false

    function getIcon() {
        if (isMuted || volume === 0) return "󰖁"; // muted
        if (volume <= 33) return "󰕿"; // low
        if (volume <= 66) return "󰖀"; // medium
        return "󰕾"; // high
    }

    readonly property string icon: getIcon()
    
    function toggleMute() {
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
    }
    
    function setVolume(v) {
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (v / 100.0).toFixed(2)])
    }

    property Process process: Process {
        command: ["bash", "-c", "while true; do wpctl get-volume @DEFAULT_AUDIO_SINK@; sleep 0.1; done"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let out = data.trim();
                if (out === "") return;
                
                if (out.includes("[MUTED]")) {
                    root.isMuted = true;
                } else {
                    root.isMuted = false;
                }
                let volMatch = out.match(/Volume: ([\d\.]+)/);
                if (volMatch && volMatch[1]) {
                    root.volume = Math.round(parseFloat(volMatch[1]) * 100);
                }
            }
        }
    }
}
