import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../core"
import "../../components"

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }
    
    margins {
        top: Config.barMode === "floating" ? Config.barMargin : 0
        left: Config.barMode === "floating" ? Config.barMargin : 0
        right: Config.barMode === "floating" ? Config.barMargin : 0
    }

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "myshell-bar"
    
    exclusiveZone: implicitHeight + (Config.barMode === "floating" ? Config.barMargin * 2 : 0)

    color: Config.barMode === "attached" ? Colors.surface : "transparent"
    implicitHeight: 30
    
    // Left: Workspaces
    StyledRect {
        id: leftPill
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: wsItem.width + 24
        color: Config.barMode === "attached" ? "transparent" : Qt.alpha(Colors.surface, 0.6)
        radius: Config.barMode === "attached" ? 0 : Config.borderRadius
        
        WorkspacesWidget {
            id: wsItem
            anchors.centerIn: parent
        }
    }
    
    // Center: Clock
    StyledRect {
        id: centerPill
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: clockItem.width + 32
        color: Config.barMode === "attached" ? "transparent" : Qt.alpha(Colors.surface, 0.6)
        radius: Config.barMode === "attached" ? 0 : Config.borderRadius
        
        ClockWidget {
            id: clockItem
            anchors.centerIn: parent
        }
    }
    
    // Right: Tray, Audio, Battery
    StyledRect {
        id: rightPill
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: rightContent.width + 32
        color: Config.barMode === "attached" ? "transparent" : Qt.alpha(Colors.surface, 0.6)
        radius: Config.barMode === "attached" ? 0 : Config.borderRadius
        
        Row {
            id: rightContent
            anchors.centerIn: parent
            spacing: 16
            
            // Settings Button
            Item {
                width: 24
                height: 24
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    text: "⚙"
                    color: Colors.foreground
                    font.pixelSize: 18
                    anchors.centerIn: parent
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: GlobalStates.settingsOpen = !GlobalStates.settingsOpen
                }
            }
            
            AudioWidget {}
            BatteryWidget {}
        }
    }
}
