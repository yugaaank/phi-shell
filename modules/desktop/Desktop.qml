import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../core"
import "../../components"

PanelWindow {
    id: desktop

    // Fill the whole screen
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // THIS IS THE SECRET SAUCE: Put this in the background, behind all your apps!
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "myshell-desktop"
    
    // Ensure the desktop doesn't block your mouse clicks to Hyprland!
    // We only want to see it, not interact with the empty space
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    
    Image {
        id: bgImage
        anchors.fill: parent
        source: Config.wallpaperPath !== "" ? "file://" + Config.wallpaperPath : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        visible: source != ""
    }

    
    // Desktop Clock Widget
    Column {
        anchors.centerIn: parent
        spacing: 10
        
        ClockWidget {
            font.pixelSize: 140
            anchors.horizontalCenter: parent.horizontalCenter
            layer.enabled: true
        }
        
        Text {
            text: "Welcome back, " + Quickshell.env("USER")
            color: Colors.primary
            font.pixelSize: 32
            font.family: Config.fontFamily
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
