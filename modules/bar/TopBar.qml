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
        top: Config.barMargin
        left: Config.barMargin
        right: Config.barMargin
    }

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "myshell-bar"
    
    exclusiveZone: implicitHeight + (Config.barMargin * 2)

    color: "transparent"
    implicitHeight: 30
    
    // Left: Workspaces
    StyledRect {
        id: leftPill
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: wsItem.width + 24
        color: Qt.alpha(Colors.surface, 0.6)
        radius: height / 2
        
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
        color: Qt.alpha(Colors.surface, 0.6)
        radius: height / 2
        
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
        color: Qt.alpha(Colors.surface, 0.6)
        radius: height / 2
        
        Row {
            id: rightContent
            anchors.centerIn: parent
            spacing: 16
            
            AudioWidget {}
            BatteryWidget {}
        }
    }
}
