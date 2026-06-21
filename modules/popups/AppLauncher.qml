import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../../core"
import "../../components"

PanelWindow {
    id: launcher
    
    // Fill the screen but remain invisible when not open
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "myshell-launcher"
    
    // Dim the background when launcher is open
    color: GlobalStates.launcherOpen ? Qt.rgba(0, 0, 0, 0.4) : "transparent"
    
    // Bind to the global state
    visible: GlobalStates.launcherOpen
    
    // Catch clicks outside to close
    MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.launcherOpen = false
    }
    
    // Wrapper for the actual popup window
    Item {
        width: 600
        height: 600
        anchors.centerIn: parent
    
    StyledRect {
        anchors.fill: parent
        color: Qt.alpha(Colors.surface, 0.9)
        
        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            
            // Search Bar
            StyledRect {
                width: parent.width
                height: 48
                color: Qt.alpha(Colors.foreground, 0.1)
                radius: 8
                
                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.margins: 12
                    color: Colors.foreground
                    font.pixelSize: 18
                    font.family: Config.fontFamily
                    verticalAlignment: TextInput.AlignVCenter
                    // Ensure it grabs focus when the launcher opens
                    onVisibleChanged: if (visible) forceActiveFocus()
                }
            }
            
            // App List
            ListView {
                id: appList
                width: parent.width
                height: parent.height - 64
                clip: true
                spacing: 8
                
                model: []
                
                // Read apps.json
                FileView {
                    path: Quickshell.env("HOME") + "/.config/myshell/apps.json"
                    onTextChanged: {
                        try {
                            appList.model = JSON.parse(text());
                        } catch (e) {
                            console.error("Error parsing apps.json", e);
                        }
                    }
                }
                
                delegate: StyledRect {
                    width: appList.width
                    color: "transparent"
                    radius: 8
                    
                    // Filter based on search input
                    property bool matchesSearch: searchInput.text === "" || modelData.name.toLowerCase().includes(searchInput.text.toLowerCase())
                    visible: matchesSearch
                    height: visible ? 56 : 0
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 12
                        
                        // Fake icon for now
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 8
                            color: Colors.primary
                            Text {
                                text: modelData.name.charAt(0).toUpperCase()
                                anchors.centerIn: parent
                                color: Colors.surface
                                font.bold: true
                            }
                        }
                        
                        Text {
                            text: modelData.name
                            color: Colors.foreground
                            font.pixelSize: 16
                            font.family: Config.fontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.execDetached(["bash", "-c", "hyprctl dispatch exec \"" + modelData.exec + "\" || " + modelData.exec])
                            GlobalStates.launcherOpen = false
                            searchInput.text = ""
                        }
                        
                        Rectangle {
                            anchors.fill: parent
                            color: "white"
                            opacity: parent.containsMouse ? 0.1 : 0
                            radius: 8
                        }
                    }
                }
            }
        }
    }
}
}
