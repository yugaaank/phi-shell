import QtQuick
import "../core"
import "../services"

Item {
    width: row.width
    height: row.height

    Row {
        id: row
        spacing: 5

        Text {
            text: AudioService.icon
            color: AudioService.isMuted ? Colors.secondary : Colors.primary
            font.family: Config.fontFamily
            font.bold: true
        }

        Text {
            text: AudioService.volume + "%"
            color: Colors.foreground
            font.family: Config.fontFamily
            font.bold: true
        }
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: AudioService.toggleMute()
    }
}
