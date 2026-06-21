import QtQuick
import QtQuick.Layouts
import "../../core"
import Quickshell

Item {
    id: root
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24
        
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "➖ Bar & UI"
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
        
        SettingCard {
            Layout.fillWidth: true
            
            SettingRowDropdown {
                title: "Bar Mode"
                description: "Choose whether the bar floats as separate pills or attaches as a solid bar."
                model: ["floating", "attached"]
                currentIndex: Config.barMode === "attached" ? 1 : 0
                onActivated: function(index, text) {
                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .layout.barMode '\"" + text + "\"'"])
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Qt.alpha(Colors.surfaceBorder, 0.5) }
            
            SettingRowTextInput {
                title: "Left Widgets"
                description: "Comma-separated list (e.g. ActiveWindowWidget, WorkspacesWidget)"
                textValue: Config.barLeft.join(", ")
                onEdited: function(newText) {
                    let arr = newText.split(",").map(s => s.trim()).filter(s => s !== "");
                    let jsonStr = JSON.stringify(arr);
                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .layout.barLeft '" + jsonStr + "'"])
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Qt.alpha(Colors.surfaceBorder, 0.5) }
            
            SettingRowTextInput {
                title: "Center Widgets"
                description: "Comma-separated list (e.g. WorkspacesWidget)"
                textValue: Config.barCenter.join(", ")
                onEdited: function(newText) {
                    let arr = newText.split(",").map(s => s.trim()).filter(s => s !== "");
                    let jsonStr = JSON.stringify(arr);
                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .layout.barCenter '" + jsonStr + "'"])
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Qt.alpha(Colors.surfaceBorder, 0.5) }
            
            SettingRowTextInput {
                title: "Right Widgets"
                description: "Comma-separated list (e.g. AudioWidget, BatteryWidget, ClockWidget)"
                textValue: Config.barRight.join(", ")
                onEdited: function(newText) {
                    let arr = newText.split(",").map(s => s.trim()).filter(s => s !== "");
                    let jsonStr = JSON.stringify(arr);
                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .layout.barRight '" + jsonStr + "'"])
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Qt.alpha(Colors.surfaceBorder, 0.5) }
            
            SettingRowToggle {
                title: "Widgets Outline"
                description: "Adds a subtle border outline to all bar widgets."
                checked: Config.widgetOutline
                onToggled: function(checked) {
                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .appearance.widgetOutline " + (checked ? "true" : "false")])
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.alpha(Colors.surfaceBorder, 0.5)
            }
            
            SettingRowSlider {
                title: "Border Radius"
                description: "Controls the roundness of corners for all shell elements."
                from: 0
                to: 32
                stepSize: 1
                value: Config.borderRadius
                onValueChanged: {
                    if (value !== Config.borderRadius) {
                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .appearance.borderRadius " + value])
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true } // spacer
    }
}
