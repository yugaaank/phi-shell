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
                text: "⚙️ General"
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
            
            SettingRowToggle {
                title: "Show Battery"
                description: "Display the battery percentage widget in the top bar."
                checked: Config.showBattery
                onToggled: function(checked) {
                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/update_config.sh .widgets.showBattery " + (checked ? "true" : "false")])
                }
            }
        }
        
        Item { Layout.fillHeight: true } // spacer
    }
}
