import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "../../core"
import "../../components"
import Quickshell

Window {
    id: settingsWindow
    width: 600
    height: 700
    title: "MyShell Settings"
    color: Colors.background
    
    property bool isOpen: GlobalStates.settingsOpen
    visible: isOpen
    
    // When the window is closed natively via Wayland (like the X button)
    onClosing: GlobalStates.settingsOpen = false
    
    Column {
        anchors.fill: parent
        anchors.margins: 32
        spacing: 24
        
        Text {
            text: "MyShell Settings"
            color: Colors.primary
            font.pixelSize: 32
            font.bold: true
            font.family: Config.fontFamily
        }
        
        Rectangle {
            width: parent.width
            height: 1
            color: Colors.surfaceBorder
        }
        
        // --- Setting: Bar Mode ---
        Row {
            spacing: 16
            width: parent.width
            
            Text {
                text: "Bar Mode:"
                color: Colors.foreground
                font.pixelSize: 18
                font.family: Config.fontFamily
                width: 150
                anchors.verticalCenter: parent.verticalCenter
            }
            
            StyledRect {
                width: 120
                height: 40
                color: Config.barMode === "floating" ? Colors.primary : Colors.surface
                Text {
                    text: "Floating"
                    anchors.centerIn: parent
                    color: Config.barMode === "floating" ? Colors.surface : Colors.foreground
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .layout.barMode '\"floating\"'"])
                }
            }
            
            StyledRect {
                width: 120
                height: 40
                color: Config.barMode === "attached" ? Colors.primary : Colors.surface
                Text {
                    text: "Attached"
                    anchors.centerIn: parent
                    color: Config.barMode === "attached" ? Colors.surface : Colors.foreground
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .layout.barMode '\"attached\"'"])
                }
            }
        }
        
        // --- Setting: Border Radius ---
        Row {
            spacing: 16
            width: parent.width
            
            Text {
                text: "Border Radius:"
                color: Colors.foreground
                font.pixelSize: 18
                font.family: Config.fontFamily
                width: 150
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Slider {
                id: radiusSlider
                width: 250
                from: 0
                to: 32
                value: Config.borderRadius
                stepSize: 1
                anchors.verticalCenter: parent.verticalCenter
                
                onValueChanged: {
                    if (value !== Config.borderRadius) {
                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .appearance.borderRadius " + value])
                    }
                }
            }
            
            Text {
                text: radiusSlider.value + "px"
                color: Colors.foreground
                font.pixelSize: 18
                font.family: Config.fontFamily
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // --- Setting: Show Battery ---
        Row {
            spacing: 16
            width: parent.width
            
            Text {
                text: "Show Battery:"
                color: Colors.foreground
                font.pixelSize: 18
                font.family: Config.fontFamily
                width: 150
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Switch {
                checked: Config.showBattery
                onCheckedChanged: {
                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .widgets.showBattery " + (checked ? "true" : "false")])
                }
            }
        }
    }
}
