import QtQuick
import "../core"
import "../services"

Text {
    id: timeText
    text: ClockService.time + " • " + ClockService.date
    color: Colors.foreground
    font.family: Config.fontFamily
    font.bold: true
}
