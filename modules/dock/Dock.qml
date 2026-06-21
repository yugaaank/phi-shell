import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../core"
import "../../components"

PanelWindow {
    id: dock

    // Anchor strictly to the bottom of the screen
    anchors {
        bottom: true
    }

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "myshell-dock"

    color: "transparent"
    
    // Push it off the bottom edge by your custom margin
    margins {
        bottom: Config.barMargin
    }

    // Dynamic sizing based on your icon size config
    implicitHeight: Config.dockIconSize + 10
    implicitWidth: dockRow.implicitWidth + 10

    StyledRect {
        anchors.fill: parent
        color: Qt.alpha(Colors.surface, 0.6)
        
        Row {
            id: dockRow
            anchors.centerIn: parent
            spacing: 16
            
            // App Launcher Button
            Rectangle {
                width: Config.dockIconSize
                height: Config.dockIconSize
                radius: Config.borderRadius > 0 ? Config.dockIconSize / 4 : 0
                color: Colors.primary
                
                Text {
                    text: "▦"
                    anchors.centerIn: parent
                    color: Colors.surface
                    font.pixelSize: 24
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        GlobalStates.launcherOpen = !GlobalStates.launcherOpen
                    }
                    
                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        opacity: parent.containsMouse ? 0.2 : 0
                        radius: parent.radius
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }
            }
            
            // Separator
            Rectangle {
                width: 2
                height: Config.dockIconSize * 0.6
                anchors.verticalCenter: parent.verticalCenter
                color: Colors.surfaceBorder
                radius: 1
            }
            
            // Running applications from Wayland
            Repeater {
                model: ToplevelManager.toplevels
                
                Rectangle {
                    width: Config.dockIconSize
                    height: Config.dockIconSize
                    radius: Config.borderRadius > 0 ? Config.dockIconSize / 4 : 0
                    color: modelData === ToplevelManager.activeToplevel ? Colors.primary : Colors.surfaceBorder
                    
                    Behavior on color { ColorAnimation { duration: 250 } }
                    
                    Text {
                        // Use the first letter of the app ID as a placeholder icon
                        text: modelData.appId ? modelData.appId.charAt(0).toUpperCase() : "?"
                        anchors.centerIn: parent
                        color: Colors.foreground
                        font.bold: true
                        font.family: Config.fontFamily
                        font.pixelSize: 20
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.activate) {
                                modelData.activate()
                            }
                        }
                        
                        Rectangle {
                            anchors.fill: parent
                            color: "white"
                            opacity: parent.containsMouse ? 0.1 : 0
                            radius: parent.radius
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }
                    }
                }
            }
        }
    }
}
