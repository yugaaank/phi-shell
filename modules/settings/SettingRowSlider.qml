import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../core"

Item {
    id: root
    Layout.fillWidth: true
    implicitHeight: 64
    
    property string title: "Setting Title"
    property string description: "Setting description goes here."
    property alias value: slider.value
    property alias from: slider.from
    property alias to: slider.to
    property alias stepSize: slider.stepSize
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 16
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            
            Text {
                text: root.title
                color: Colors.foreground
                font.pixelSize: 15
                font.family: Config.fontFamily
                font.bold: true
            }
            
            Text {
                text: root.description
                color: Qt.alpha(Colors.foreground, 0.6)
                font.pixelSize: 13
                font.family: Config.fontFamily
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
        
        Text {
            text: slider.value
            color: Colors.foreground
            font.pixelSize: 14
            font.family: Config.fontFamily
        }
        
        Slider {
            id: slider
            Layout.preferredWidth: 150
        }
    }
}
