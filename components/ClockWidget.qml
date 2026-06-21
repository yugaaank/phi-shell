import QtQuick
import "../core"
import "../services"

Text {
    id: timeText
    text: Qt.formatDateTime(new Date(), "HH:mm • dddd, dd/MM")
    color: Colors.foreground
    font.family: Config.fontFamily
    font.bold: true

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeText.text = Qt.formatDateTime(new Date(), "HH:mm • dddd, dd/MM")
        }
    }
}
