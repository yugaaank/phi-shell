import QtQuick
import QtQuick.Layouts
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
    implicitHeight: 36
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 16
        
        // --- Left Section ---
        RowLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            
            // Active Window
            StyledRect {
                Layout.preferredHeight: 32
                Layout.preferredWidth: activeWindow.width + 24
                color: Qt.alpha(Colors.surface, Config.barMode === "attached" ? 0.3 : 0.6)
                radius: Config.barMode === "attached" ? 16 : Config.borderRadius
                
                ActiveWindowWidget {
                    id: activeWindow
                    anchors.centerIn: parent
                }
            }
        }
        
        // Spacer
        Item { Layout.fillWidth: true }
        
        // --- Center Section ---
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            
            // Workspaces
            StyledRect {
                Layout.preferredHeight: 32
                Layout.preferredWidth: wsItem.width + 24
                color: Qt.alpha(Colors.surface, Config.barMode === "attached" ? 0.3 : 0.6)
                radius: Config.barMode === "attached" ? 16 : Config.borderRadius
                
                WorkspacesWidget {
                    id: wsItem
                    anchors.centerIn: parent
                }
            }
        }
        
        // Spacer
        Item { Layout.fillWidth: true }
        
        // --- Right Section ---
        RowLayout {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            spacing: 8
            
            // Audio, Battery, Clock & Settings
            StyledRect {
                Layout.preferredHeight: 32
                Layout.preferredWidth: rightStuff.width + 32
                color: Qt.alpha(Colors.surface, Config.barMode === "attached" ? 0.3 : 0.6)
                radius: Config.barMode === "attached" ? 16 : Config.borderRadius
                
                Row {
                    id: rightStuff
                    anchors.centerIn: parent
                    spacing: 16
                    
                    AudioWidget {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    BatteryWidget {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    ClockWidget {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    // Settings Button
                    MouseArea {
                        width: 16
                        height: 16
                        anchors.verticalCenter: parent.verticalCenter
                        cursorShape: Qt.PointingHandCursor
                        onClicked: GlobalStates.settingsOpen = !GlobalStates.settingsOpen
                        Text {
                            text: "⚙"
                            color: Colors.foreground
                            anchors.centerIn: parent
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }
    }
}
