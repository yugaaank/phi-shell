import QtQuick
import "../core"
import "../services"

Row {
    spacing: 5
    visible: Config.showBattery

    Text {
        text: BatteryService.icon
        color: BatteryService.isCharging ? Colors.primary : (BatteryService.percent <= 20 ? Colors.secondary : Colors.primary)
        font.family: Config.fontFamily
        font.bold: true
        visible: BatteryService.isReady
    }

    Text {
        text: BatteryService.percent + "%"
        color: Colors.foreground
        font.family: Config.fontFamily
        font.bold: true
        visible: BatteryService.isReady
    }
    
    // Fallback for desktop machines
    Text {
        text: "AC Power"
        color: Colors.secondary
        font.family: Config.fontFamily
        font.bold: true
        visible: !BatteryService.isReady
    }
}
