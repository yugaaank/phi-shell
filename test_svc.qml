import QtQuick; import "services"; QtObject { Component.onCompleted: { console.log(BatteryService.isReady); Qt.quit(); } }
