import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "../../core"
import "../../components"
import Quickshell

Window {
    id: settingsWindow
    width: 900
    height: 700
    title: "MyShell Settings"
    color: Colors.surface
    
    property bool isOpen: GlobalStates.settingsOpen
    visible: isOpen
    
    // When the window is closed natively via Wayland
    onClosing: GlobalStates.settingsOpen = false
    
    // The currently selected page index
    property int currentPage: 0
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // --- Sidebar ---
        Rectangle {
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            color: "transparent"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8
                
                // Top: Search Bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: 18
                    color: "transparent"
                    border.color: Colors.surfaceBorder
                    border.width: 1
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        Text {
                            text: "🔍"
                            color: Colors.foreground
                            opacity: 0.6
                        }
                        
                        TextInput {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Colors.foreground
                            font.pixelSize: 14
                            font.family: Config.fontFamily
                            verticalAlignment: TextInput.AlignVCenter
                            Text {
                                text: "Search"
                                color: Colors.foreground
                                opacity: 0.4
                                font.pixelSize: 14
                                font.family: Config.fontFamily
                                anchors.verticalCenter: parent.verticalCenter
                                visible: parent.text === "" && !parent.activeFocus
                            }
                        }
                    }
                }
                
                Item { Layout.preferredHeight: 8 } // Spacer
                
                // Sidebar Menu Items
                ListView {
                    id: sidebarMenu
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 4
                    
                    model: [
                        { name: "General", icon: "⚙️" },
                        { name: "User Interface", icon: "🖥️" },
                        { name: "Color Scheme", icon: "🎨" },
                        { name: "Wallpaper", icon: "🖼️" },
                        { name: "Bar", icon: "➖" },
                        { name: "Dock", icon: "📱" },
                        { name: "Desktop Widgets", icon: "⏱️" }
                    ]
                    
                    delegate: Rectangle {
                        width: sidebarMenu.width
                        height: 40
                        radius: 20
                        color: settingsWindow.currentPage === index ? Colors.primary : "transparent"
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 12
                            
                            Text {
                                text: modelData.icon
                                color: settingsWindow.currentPage === index ? Colors.surface : Colors.foreground
                                font.pixelSize: 16
                            }
                            
                            Text {
                                Layout.fillWidth: true
                                text: modelData.name
                                color: settingsWindow.currentPage === index ? Colors.surface : Colors.foreground
                                font.pixelSize: 14
                                font.family: Config.fontFamily
                                font.bold: settingsWindow.currentPage === index
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: settingsWindow.currentPage = index
                            
                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "white"
                                opacity: parent.containsMouse && settingsWindow.currentPage !== index ? 0.05 : 0
                            }
                        }
                    }
                }
            }
            
            // Right border for sidebar
            Rectangle {
                width: 1
                height: parent.height
                anchors.right: parent.right
                color: Qt.alpha(Colors.surfaceBorder, 0.5)
            }
        }
        
        // --- Content Area ---
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            
            StackLayout {
                anchors.fill: parent
                currentIndex: settingsWindow.currentPage
                
                // 0: General
                SettingsGeneralPage {}
                
                // 1: User Interface
                Item {}
                
                // 2: Color Scheme
                SettingsColorPage {}
                
                // 3: Wallpaper
                Item {}
                
                // 4: Bar
                SettingsBarPage {}
                
                // 5: Dock
                Item {}
                
                // 6: Desktop Widgets
                Item {}
            }
        }
    }
}
