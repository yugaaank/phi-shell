import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../core"

Row {
    spacing: 12
    anchors.verticalCenter: parent.verticalCenter
    
    Repeater {
        // Automatically updates when Hyprland workspaces change
        model: Hyprland.workspaces

        Rectangle {
            // Quickshell models expose the object as modelData, or the properties directly.
            property int wsId: typeof modelData !== 'undefined' ? modelData.id : id
            property bool isActive: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === wsId
            
            width: isActive ? 24 : 8
            height: isActive ? 24 : 8
            radius: width / 2
            anchors.verticalCenter: parent.verticalCenter
            
            color: isActive ? Colors.primary : Colors.surfaceBorder
            
            Behavior on width { NumberAnimation { duration: 200 } }
            Behavior on height { NumberAnimation { duration: 200 } }
            Behavior on color { ColorAnimation { duration: 200 } }
            
            // Icon for active workspace
            Text {
                text: "✦"
                anchors.centerIn: parent
                color: Colors.surface
                font.pixelSize: 12
                opacity: parent.isActive ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Quickshell.execDetached(["bash", "-c", "hyprctl dispatch workspace " + wsId])
                }
            }
        }
    }
}
