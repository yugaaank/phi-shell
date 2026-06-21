pragma Singleton
import QtQuick

QtObject {
    property bool launcherOpen: false
    property bool settingsOpen: false
    property bool dashboardOpen: false
    property bool sidebarOpen: false
    
    property string uptime: "..."
    property string wifiName: "Not connected"
    property bool wifiConnected: false
    property string bluetoothName: "Not connected"
    property bool bluetoothConnected: false
    property bool micMuted: false
    property bool audioMuted: false
    property bool nightLightOn: false
    
    property int pomodoroTimeRemaining: 25 * 60
    property bool pomodoroRunning: false
}
