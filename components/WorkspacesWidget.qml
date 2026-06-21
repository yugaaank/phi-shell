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
            // We use a small trick to safely get the workspace ID.
            property int wsId: typeof modelData !== 'undefined' ? modelData.id : id
            
            // Check if this workspace is the currently focused one
            property bool isActive: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === wsId
            
            width: isActive ? 24 : 12
            height: 12
            radius: 6
            
            color: isActive ? Colors.primary : Colors.surfaceBorder
            
            Behavior on width {
                NumberAnimation { duration: 250; easing.type: Easing.OutExpo }
            }
            
            Behavior on color {
                ColorAnimation { duration: 250 }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    // Try the Lua dispatch mode from Noctalia, fallback to standard
                    Quickshell.execDetached(["bash", "-c", "hyprctl dispatch workspace " + wsId + " || hyprctl dispatch \"hl.dsp.focus({ workspace = " + wsId + " })\""])
                }
            }
        }
    }
}
