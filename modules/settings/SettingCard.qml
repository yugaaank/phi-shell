import QtQuick
import QtQuick.Layouts
import "../../core"

Rectangle {
    id: root
    width: parent ? parent.width : 0
    // Height wraps children
    implicitHeight: layout.implicitHeight + 24
    
    color: Qt.alpha(Colors.surfaceBorder, 0.2) // slightly darker/lighter than surface
    radius: 12
    border.color: Qt.alpha(Colors.surfaceBorder, 0.5)
    border.width: 1
    
    default property alias content: layout.data
    
    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 0
    }
}
