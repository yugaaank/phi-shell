import QtQuick
import "../core"

Rectangle {
    id: root
    
    color: Colors.surface
    radius: Config.borderRadius
    
    border.color: Config.widgetOutline ? Qt.alpha(Colors.surfaceBorder, 0.8) : "transparent"
    border.width: Config.widgetOutline ? 1 : 0
    
    Behavior on color {
        ColorAnimation { duration: 300; easing.type: Easing.OutCubic }
    }
    
    Behavior on border.color {
        ColorAnimation { duration: 300; easing.type: Easing.OutCubic }
    }
}
