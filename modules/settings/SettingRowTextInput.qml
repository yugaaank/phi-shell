import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../core"

Item {
    id: root
    Layout.fillWidth: true
    implicitHeight: layout.implicitHeight
    
    property string title: "Setting Title"
    property string description: "Setting description goes here."
    property string textValue: ""
    property string placeholder: ""
    
    signal edited(string newText)
    
    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 16
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            
            Text {
                text: root.title
                color: Colors.foreground
                font.family: Config.fontFamily
                font.pixelSize: 14
                font.bold: true
            }
            
            Text {
                text: root.description
                color: Qt.alpha(Colors.foreground, 0.7)
                font.family: Config.fontFamily
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
        
        TextField {
            Layout.preferredWidth: 250
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            text: root.textValue
            placeholderText: root.placeholder
            
            color: Colors.foreground
            font.family: Config.fontFamily
            font.pixelSize: 13
            
            background: Rectangle {
                color: Qt.alpha(Colors.surfaceBorder, 0.3)
                radius: 8
                border.color: parent.activeFocus ? Colors.primary : Colors.surfaceBorder
                border.width: parent.activeFocus ? 2 : 1
            }
            
            onEditingFinished: {
                root.edited(text)
            }
        }
    }
}
