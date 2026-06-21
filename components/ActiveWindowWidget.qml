import QtQuick
import Quickshell
import Quickshell.Wayland
import "../core"

Row {
    id: root
    spacing: 8
    
    // Sparkle icon Pill
    Rectangle {
        width: 24
        height: 24
        radius: 12
        color: Qt.alpha(Colors.surfaceBorder, 0.5)
        anchors.verticalCenter: parent.verticalCenter
        
        Text {
            text: "✦"
            color: Colors.foreground
            anchors.centerIn: parent
            font.pixelSize: 14
        }
    }
    
    Column {
        anchors.verticalCenter: parent.verticalCenter
        
        Text {
            text: ToplevelManager.activeToplevel ? (ToplevelManager.activeToplevel.appId || "Unknown") : "Desktop"
            color: Qt.alpha(Colors.foreground, 0.6)
            font.pixelSize: 11
            font.family: Config.fontFamily
        }
        
        Text {
            text: ToplevelManager.activeToplevel ? (ToplevelManager.activeToplevel.title || "") : "Home"
            color: Colors.foreground
            font.pixelSize: 13
            font.bold: true
            font.family: Config.fontFamily
            // Ellipsize long titles
            elide: Text.ElideRight
            width: Math.min(implicitWidth, 200)
        }
    }
}
