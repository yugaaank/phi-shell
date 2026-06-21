import QtQuick
import QtQuick.Layouts
import "../../core"

Item {
    id: root
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24
        
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "🎨 Color Scheme"
                color: Colors.foreground
                font.pixelSize: 24
                font.bold: true
                font.family: Config.fontFamily
                Layout.fillWidth: true
            }
            
            Rectangle {
                width: 32
                height: 32
                radius: 16
                color: Qt.alpha(Colors.surfaceBorder, 0.5)
                
                Text {
                    text: "✕"
                    anchors.centerIn: parent
                    color: Colors.foreground
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: GlobalStates.settingsOpen = false
                }
            }
        }
        
        // Segmented Button Mock
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            spacing: 0
            
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Colors.primary
                radius: 6
                
                Text {
                    text: "Colors"
                    color: Colors.surface
                    anchors.centerIn: parent
                    font.bold: true
                    font.family: Config.fontFamily
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"
                border.color: Colors.surfaceBorder
                radius: 6
                
                Text {
                    text: "Templates"
                    color: Colors.foreground
                    anchors.centerIn: parent
                    font.family: Config.fontFamily
                }
            }
        }
        
        SettingCard {
            Layout.fillWidth: true
            
            SettingRowToggle {
                title: "Dark Mode"
                description: "Switches to a darker theme for easier viewing at night."
                checked: true
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.alpha(Colors.surfaceBorder, 0.5)
            }
            
            SettingRowDropdown {
                title: "Dark Mode schedule"
                description: "Enables automatic switching between Light and Dark Mode."
                model: ["Off", "Sunset to Sunrise"]
                currentIndex: 0
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.alpha(Colors.surfaceBorder, 0.5)
            }
            
            SettingRowToggle {
                title: "Use wallpaper colors"
                description: "Generate color schemes from your wallpaper. Automatically extracts colors to create a cohesive theme."
                checked: true
            }
        }
        
        // Predefined color schemes
        Text {
            text: "Predefined color schemes"
            color: Colors.primary
            font.pixelSize: 18
            font.family: Config.fontFamily
            Layout.topMargin: 16
        }
        Text {
            text: "Choose from a collection of predefined color schemes."
            color: Qt.alpha(Colors.foreground, 0.6)
            font.pixelSize: 13
            font.family: Config.fontFamily
        }
        
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 12
            columnSpacing: 12
            
            Repeater {
                model: ["Ayu", "Catppuccin", "Dracula", "Nord"]
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    radius: 8
                    color: "transparent"
                    border.color: Colors.surfaceBorder
                    border.width: 1
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        
                        Text {
                            text: modelData
                            color: Colors.foreground
                            font.family: Config.fontFamily
                            Layout.fillWidth: true
                        }
                        
                        Row {
                            spacing: 4
                            Repeater {
                                model: 4
                                Rectangle {
                                    width: 12
                                    height: 12
                                    radius: 6
                                    color: Colors.primary
                                }
                            }
                        }
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true } // spacer
    }
}
