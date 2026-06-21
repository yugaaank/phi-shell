import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "../../core"
import "../../components"

PanelWindow {
    id: dashboard
    
    // Fill the screen but remain invisible when not open
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "myshell-dashboard"
    
    // Transparent background
    color: "transparent"
    
    // Bind to the global state
    visible: GlobalStates.dashboardOpen
    
    // Catch clicks outside to close
    MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.dashboardOpen = false
    }
    
    // Wrapper for the actual popup window
    Item {
        width: 380
        height: layout.implicitHeight + 32
        
        // Anchor to the top center, below the bar
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 40 + (Config.barMode === "floating" ? Config.barMargin : 0)
    
        StyledRect {
            anchors.fill: parent
            color: Qt.alpha(Colors.surface, 0.9)
            radius: Config.borderRadius
            border.color: Colors.surfaceBorder
            border.width: 1
            
            // Prevent clicks inside the dashboard from bubbling to the close area
            MouseArea {
                anchors.fill: parent
                onClicked: {}
            }
            
            ColumnLayout {
                id: layout
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                
                // --- Welcome Section ---
                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    color: Qt.alpha(Colors.surfaceContainer, 0.5)
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16
                        
                        Rectangle {
                            width: 48
                            height: 48
                            radius: 24
                            color: Colors.primary
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🐧"
                                font.pixelSize: 24
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            Text {
                                text: "Good " + (new Date().getHours() < 12 ? "Morning" : new Date().getHours() < 18 ? "Afternoon" : "Evening") + ","
                                color: Qt.alpha(Colors.foreground, 0.7)
                                font.family: Config.fontFamily
                                font.pixelSize: 14
                            }
                            
                            Text {
                                text: Quickshell.env("USER") || "User"
                                color: Colors.foreground
                                font.family: Config.fontFamily
                                font.pixelSize: 20
                                font.bold: true
                            }
                        }
                    }
                }
                
                // --- Calendar Section ---
                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 250 // Rough height for a simple calendar
                    color: Qt.alpha(Colors.surfaceContainer, 0.5)
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8
                        
                        Text {
                            text: Qt.formatDate(new Date(), "MMMM yyyy")
                            color: Colors.primary
                            font.family: Config.fontFamily
                            font.pixelSize: 16
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 7
                            columnSpacing: 4
                            rowSpacing: 4
                            
                            Repeater {
                                model: ["S", "M", "T", "W", "T", "F", "S"]
                                Text {
                                    text: modelData
                                    color: Qt.alpha(Colors.foreground, 0.5)
                                    font.family: Config.fontFamily
                                    font.pixelSize: 12
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.fillWidth: true
                                }
                            }
                            
                            // Simple 1-30 mockup for now
                            Repeater {
                                model: 31
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: width
                                    radius: width / 2
                                    color: modelData === new Date().getDate() - 1 ? Colors.primary : "transparent"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData + 1
                                        color: modelData === new Date().getDate() - 1 ? Colors.surface : Colors.foreground
                                        font.family: Config.fontFamily
                                        font.pixelSize: 12
                                    }
                                }
                            }
                        }
                    }
                }
                
                // --- Music Player Section ---
                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 90
                    color: Qt.alpha(Colors.surfaceContainer, 0.5)
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16
                        
                        Rectangle {
                            width: 60
                            height: 60
                            radius: 8
                            color: Colors.surfaceBorder
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🎵"
                                font.pixelSize: 24
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            Text {
                                text: "Not Playing"
                                color: Colors.foreground
                                font.family: Config.fontFamily
                                font.pixelSize: 16
                                font.bold: true
                            }
                            
                            Text {
                                text: "Play some music..."
                                color: Qt.alpha(Colors.foreground, 0.7)
                                font.family: Config.fontFamily
                                font.pixelSize: 12
                            }
                            
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16
                                
                                Item { Layout.fillWidth: true } // spacer
                                
                                Text { text: "󰒮"; color: Colors.foreground; font.pixelSize: 18 }
                                Text { text: "󰐊"; color: Colors.primary; font.pixelSize: 24 }
                                Text { text: "󰒭"; color: Colors.foreground; font.pixelSize: 18 }
                                
                                Item { Layout.fillWidth: true } // spacer
                            }
                        }
                    }
                }
            }
        }
    }
}
