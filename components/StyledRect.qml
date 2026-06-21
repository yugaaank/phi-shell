import QtQuick
import "../core"

Rectangle {
    id: root
    
    color: Colors.surface
    border.color: Colors.surfaceBorder
    border.width: 1
    radius: Config.borderRadius
    
    Behavior on color { ColorAnimation { duration: 350 } }
    Behavior on border.color { ColorAnimation { duration: 350 } }
}
