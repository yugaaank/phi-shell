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
    
    Item {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        
        // --- Left Section ---
        Item {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: leftPill.height
            width: leftPill.width
            
            StyledRect {
                id: leftPill
                anchors.centerIn: parent
                height: 32
                width: leftLayout.implicitWidth + 24
                color: Qt.alpha(Colors.surface, Config.barMode === "attached" ? 0.3 : 0.6)
                radius: Config.barMode === "attached" ? 16 : Config.borderRadius
                visible: Config.barLeft.length > 0
                
                Row {
                    id: leftLayout
                    anchors.centerIn: parent
                    spacing: 16
                    Repeater {
                        model: Config.barLeft
                        Loader {
                            source: "../../components/" + modelData + ".qml"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
        
        // --- Center Section ---
        Item {
            anchors.centerIn: parent
            height: centerPill.height
            width: centerPill.width
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: GlobalStates.dashboardOpen = !GlobalStates.dashboardOpen
            }
            
            StyledRect {
                id: centerPill
                anchors.centerIn: parent
                height: 32
                width: centerLayout.implicitWidth + 24
                color: Qt.alpha(Colors.surface, Config.barMode === "attached" ? 0.3 : 0.6)
                radius: Config.barMode === "attached" ? 16 : Config.borderRadius
                visible: Config.barCenter.length > 0
                
                Row {
                    id: centerLayout
                    anchors.centerIn: parent
                    spacing: 16
                    Repeater {
                        model: Config.barCenter
                        Loader {
                            source: "../../components/" + modelData + ".qml"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
        
        // --- Right Section ---
        Item {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: rightPill.height
            width: rightPill.width
            
            StyledRect {
                id: rightPill
                anchors.centerIn: parent
                height: 32
                width: rightLayout.implicitWidth + 24
                color: Qt.alpha(Colors.surface, Config.barMode === "attached" ? 0.3 : 0.6)
                radius: Config.barMode === "attached" ? 16 : Config.borderRadius
                visible: Config.barRight.length > 0
                
                Row {
                    id: rightLayout
                    anchors.centerIn: parent
                    spacing: 16
                    Repeater {
                        model: Config.barRight
                        Loader {
                            source: "../../components/" + modelData + ".qml"
                            anchors.verticalCenter: parent.verticalCenter
                        }
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
