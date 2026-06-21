import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "../../core"
import "../../components"

PanelWindow {
    id: sidebar
    
    // Fill the screen but remain invisible when not open
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "myshell-sidebar"
    
    // Transparent background for overlay
    color: "transparent"
    
    // Bind to the global state
    visible: GlobalStates.sidebarOpen
    
    // --- Pomodoro Engine ---
    Timer {
        interval: 1000
        running: GlobalStates.pomodoroRunning && GlobalStates.pomodoroTimeRemaining > 0
        repeat: true
        onTriggered: {
            GlobalStates.pomodoroTimeRemaining -= 1;
            if (GlobalStates.pomodoroTimeRemaining === 0) {
                GlobalStates.pomodoroRunning = false;
                // play sound or notify
                Quickshell.execDetached(["notify-send", "Pomodoro finished!", "Time for a break."]);
            }
        }
    }
    
    // Catch clicks outside to close
    MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.sidebarOpen = false
    }
    
    // The actual sidebar container
    Item {
        width: 420
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            topMargin: 40 + (Config.barMode === "floating" ? Config.barMargin : 0)
            bottomMargin: 16
            rightMargin: 12
        }
        
        StyledRect {
            anchors.fill: parent
            color: Qt.alpha(Colors.surface, 0.95)
            radius: Config.borderRadius
            border.color: Colors.surfaceBorder
            border.width: 1
            
            // Prevent clicks inside the sidebar from closing it
            MouseArea {
                anchors.fill: parent
                onClicked: {}
            }
            
            // --- Update Timers ---
            Timer {
                interval: 60000; running: GlobalStates.sidebarOpen; repeat: true; triggeredOnStart: true
                onTriggered: {
                    try {
                        let stdout = Quickshell.exec("uptime -p");
                        GlobalStates.uptime = stdout.trim();
                    } catch(e) {}
                }
            }
            
            Timer {
                interval: 5000; running: GlobalStates.sidebarOpen; repeat: true; triggeredOnStart: true
                onTriggered: {
                    try {
                        let wifi = Quickshell.exec("nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2").trim();
                        GlobalStates.wifiName = wifi !== "" ? wifi : "Not connected";
                        GlobalStates.wifiConnected = wifi !== "";
                        
                        let bt = Quickshell.exec("bluetoothctl devices Connected | head -n 1 | cut -d ' ' -f 3-").trim();
                        GlobalStates.bluetoothName = bt !== "" ? bt : "Not connected";
                        GlobalStates.bluetoothConnected = bt !== "";
                        
                        let micStatus = Quickshell.exec("wpctl get-volume @DEFAULT_AUDIO_SOURCE@").trim();
                        GlobalStates.micMuted = micStatus.includes("MUTED");
                        
                        let sinkStatus = Quickshell.exec("wpctl get-volume @DEFAULT_AUDIO_SINK@").trim();
                        GlobalStates.audioMuted = sinkStatus.includes("MUTED");
                    } catch(e) {}
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20
                
                // --- Header Row ---
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    Text {
                        text: "󰣇" // Arch Linux icon
                        font.pixelSize: 24
                        color: Colors.foreground
                    }
                    
                    Text {
                        text: GlobalStates.uptime
                        font.pixelSize: 14
                        font.family: Config.fontFamily
                        color: Colors.foreground
                    }
                    
                    Item { Layout.fillWidth: true } // Spacer
                    
                    // Header Buttons
                    Row {
                        spacing: 8
                        
                        Repeater {
                            model: ["󰏫", "󰑐", "", "⏻"]
                            Rectangle {
                                width: 36
                                height: 36
                                radius: 18
                                color: "transparent"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: 18
                                    color: Colors.foreground
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: parent.color = Qt.alpha(Colors.surfaceBorder, 0.5)
                                    onExited: parent.color = "transparent"
                                    onClicked: {
                                        if (modelData === "") {
                                            GlobalStates.settingsOpen = !GlobalStates.settingsOpen;
                                            GlobalStates.sidebarOpen = false;
                                        } else if (modelData === "⏻") {
                                            Quickshell.execDetached(["bash", "-c", "wlogout || systemctl poweroff"]);
                                        } else if (modelData === "󰑐") {
                                            Quickshell.execDetached(["killall", "qs"]);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // --- Quick Settings Grid ---
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    // Row 1
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        // Internet
                        StyledRect {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 64
                            Layout.preferredWidth: 160
                            color: GlobalStates.wifiConnected ? Colors.primary : Qt.alpha(Colors.surfaceBorder, 0.3)
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Quickshell.execDetached(["nm-connection-editor"])
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12
                                
                                Text { text: GlobalStates.wifiConnected ? "󰖩" : "󰖪"; font.pixelSize: 24; color: GlobalStates.wifiConnected ? Colors.onPrimary : Colors.foreground }
                                ColumnLayout {
                                    spacing: 2
                                    Text { text: "Internet"; font.pixelSize: 13; font.bold: true; color: GlobalStates.wifiConnected ? Colors.onPrimary : Colors.foreground; font.family: Config.fontFamily }
                                    Text { text: GlobalStates.wifiName; font.pixelSize: 11; color: Qt.alpha(GlobalStates.wifiConnected ? Colors.onPrimary : Colors.foreground, 0.8); font.family: Config.fontFamily }
                                }
                            }
                        }
                        
                        // Bluetooth
                        StyledRect {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 64
                            Layout.preferredWidth: 140
                            color: GlobalStates.bluetoothConnected ? Colors.primary : Qt.alpha(Colors.surfaceBorder, 0.3)
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Quickshell.execDetached(["blueman-manager"])
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12
                                
                                Text { text: "󰂯"; font.pixelSize: 24; color: GlobalStates.bluetoothConnected ? Colors.onPrimary : Colors.foreground }
                                ColumnLayout {
                                    spacing: 2
                                    Text { text: "Bluetooth"; font.pixelSize: 13; font.bold: true; color: GlobalStates.bluetoothConnected ? Colors.onPrimary : Colors.foreground; font.family: Config.fontFamily }
                                    Text { text: GlobalStates.bluetoothName; font.pixelSize: 11; color: Qt.alpha(GlobalStates.bluetoothConnected ? Colors.onPrimary : Colors.foreground, 0.8); font.family: Config.fontFamily; elide: Text.ElideRight; Layout.fillWidth: true }
                                }
                            }
                        }
                        
                        // Caffeine
                        StyledRect {
                            Layout.preferredHeight: 64
                            Layout.preferredWidth: 64
                            color: Qt.alpha(Colors.surfaceBorder, 0.3)
                            
                            Text { anchors.centerIn: parent; text: "󰅶"; font.pixelSize: 24; color: Colors.foreground }
                        }
                    }
                    
                    // Row 2
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        // Mic
                        StyledRect {
                            Layout.preferredHeight: 64
                            Layout.preferredWidth: 64
                            color: GlobalStates.micMuted ? Qt.alpha(Colors.surfaceBorder, 0.3) : Colors.primary
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Quickshell.exec(["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]);
                                    let micStatus = Quickshell.exec("wpctl get-volume @DEFAULT_AUDIO_SOURCE@").trim();
                                    GlobalStates.micMuted = micStatus.includes("MUTED");
                                }
                            }
                            
                            Text { anchors.centerIn: parent; text: GlobalStates.micMuted ? "󰍭" : "󰍬"; font.pixelSize: 24; color: GlobalStates.micMuted ? Colors.foreground : Colors.onPrimary }
                        }
                        
                        // Audio
                        StyledRect {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 64
                            Layout.preferredWidth: 140
                            color: GlobalStates.audioMuted ? Qt.alpha(Colors.surfaceBorder, 0.3) : Colors.primary
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Quickshell.exec(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
                                    let sinkStatus = Quickshell.exec("wpctl get-volume @DEFAULT_AUDIO_SINK@").trim();
                                    GlobalStates.audioMuted = sinkStatus.includes("MUTED");
                                }
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12
                                
                                Text { text: GlobalStates.audioMuted ? "󰖁" : "󰕾"; font.pixelSize: 24; color: GlobalStates.audioMuted ? Colors.foreground : Colors.onPrimary }
                                ColumnLayout {
                                    spacing: 2
                                    Text { text: "Audio output"; font.pixelSize: 13; font.bold: true; color: GlobalStates.audioMuted ? Colors.foreground : Colors.onPrimary; font.family: Config.fontFamily }
                                    Text { text: GlobalStates.audioMuted ? "Muted" : "Unmuted"; font.pixelSize: 11; color: Qt.alpha(GlobalStates.audioMuted ? Colors.foreground : Colors.onPrimary, 0.8); font.family: Config.fontFamily }
                                }
                            }
                        }
                        
                        // Night Light
                        StyledRect {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 64
                            Layout.preferredWidth: 160
                            color: GlobalStates.nightLightOn ? Colors.primary : Qt.alpha(Colors.surfaceBorder, 0.3)
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: GlobalStates.nightLightOn = !GlobalStates.nightLightOn
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12
                                
                                Text { text: "󰖔"; font.pixelSize: 24; color: GlobalStates.nightLightOn ? Colors.onPrimary : Colors.foreground }
                                ColumnLayout {
                                    spacing: 2
                                    Text { text: "Night Light"; font.pixelSize: 13; font.bold: true; color: GlobalStates.nightLightOn ? Colors.onPrimary : Colors.foreground; font.family: Config.fontFamily }
                                    Text { text: GlobalStates.nightLightOn ? "Active" : "Auto, Inactive"; font.pixelSize: 11; color: Qt.alpha(GlobalStates.nightLightOn ? Colors.onPrimary : Colors.foreground, 0.6); font.family: Config.fontFamily }
                                }
                            }
                        }
                    }
                }
                
                // --- Notifications Placeholder ---
                StyledRect {
                    Layout.fillWidth: true
                    Layout.fillHeight: true // takes remaining space
                    color: Qt.alpha(Colors.surfaceBorder, 0.1)
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        
                        // Notification list mockup
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                            
                            RowLayout {
                                anchors.fill: parent
                                spacing: 12
                                
                                Rectangle {
                                    width: 40; height: 40
                                    radius: 20
                                    color: Qt.alpha(Colors.surfaceBorder, 0.4)
                                    Text { anchors.centerIn: parent; text: "🐱"; font.pixelSize: 24 }
                                    Layout.alignment: Qt.AlignTop
                                }
                                
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: "kitty"; font.pixelSize: 12; color: Qt.alpha(Colors.foreground, 0.6); font.family: Config.fontFamily }
                                        Item { Layout.fillWidth: true }
                                        Text { text: "Now"; font.pixelSize: 11; color: Qt.alpha(Colors.foreground, 0.6); font.family: Config.fontFamily }
                                        Rectangle {
                                            width: 40; height: 24; radius: 12; color: Qt.alpha(Colors.surfaceBorder, 0.4)
                                            Row {
                                                anchors.centerIn: parent
                                                spacing: 4
                                                Text { text: "6"; color: Colors.foreground; font.pixelSize: 12; font.family: Config.fontFamily }
                                                Text { text: ""; color: Colors.foreground; font.pixelSize: 10 }
                                            }
                                        }
                                    }
                                    Text { text: "Antigravity CLI is ready for input"; font.pixelSize: 14; font.bold: true; color: Colors.foreground; font.family: Config.fontFamily; elide: Text.ElideRight; Layout.fillWidth: true }
                                    Text { text: "Antigravity CLI is ready for input"; font.pixelSize: 14; color: Qt.alpha(Colors.foreground, 0.6); font.family: Config.fontFamily; elide: Text.ElideRight; Layout.fillWidth: true }
                                }
                            }
                        }
                        
                        Item { Layout.fillHeight: true } // push footer down
                        
                        // Notifications Footer
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "󰂚"; color: Colors.foreground; font.pixelSize: 18 }
                            Item { Layout.fillWidth: true }
                            Text { text: "6 notifications"; color: Colors.foreground; font.pixelSize: 14; font.family: Config.fontFamily }
                            Item { Layout.fillWidth: true }
                            Text { text: "󰎟"; color: Colors.foreground; font.pixelSize: 18 }
                        }
                    }
                }
                
                // --- Bottom Pomodoro Panel ---
                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 320
                    color: Qt.alpha(Colors.surfaceBorder, 0.1)
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16
                        
                        // Tabs
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: ""; color: Colors.foreground; font.pixelSize: 14 }
                            Item { Layout.fillWidth: true }
                            Text { text: "󰄉 Pomodoro"; color: Colors.primary; font.pixelSize: 14; font.family: Config.fontFamily; font.bold: true }
                            Item { Layout.fillWidth: true }
                            Text { text: "󱎫 Stopwatch"; color: Qt.alpha(Colors.foreground, 0.6); font.pixelSize: 14; font.family: Config.fontFamily }
                            Item { Layout.fillWidth: true }
                        }
                        
                        // Separator with active tab indicator
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 2
                            Rectangle { width: parent.width; height: 1; color: Qt.alpha(Colors.surfaceBorder, 0.5); anchors.bottom: parent.bottom }
                            Rectangle { width: 100; height: 2; color: Colors.primary; anchors.bottom: parent.bottom; x: 120 }
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 24
                            
                            // Left Menu
                            ColumnLayout {
                                Layout.preferredWidth: 60
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 16
                                
                                Column {
                                    spacing: 4; anchors.horizontalCenter: parent.horizontalCenter
                                    Text { text: "󰃭"; font.pixelSize: 20; color: Colors.foreground; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "Calendar"; font.pixelSize: 11; font.family: Config.fontFamily; color: Colors.foreground; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                
                                Column {
                                    spacing: 4; anchors.horizontalCenter: parent.horizontalCenter
                                    Text { text: "󰄬"; font.pixelSize: 20; color: Colors.foreground; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "To Do"; font.pixelSize: 11; font.family: Config.fontFamily; color: Colors.foreground; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                
                                Rectangle {
                                    width: 64; height: 50; radius: 25; color: Qt.alpha(Colors.surfaceBorder, 0.4); anchors.horizontalCenter: parent.horizontalCenter
                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 4
                                        Text { text: "󱎫"; font.pixelSize: 20; color: Colors.foreground; anchors.horizontalCenter: parent.horizontalCenter }
                                        Text { text: "Timer"; font.pixelSize: 11; font.family: Config.fontFamily; color: Colors.foreground; anchors.horizontalCenter: parent.horizontalCenter }
                                    }
                                }
                            }
                            
                            // Pomodoro Timer Circle
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 160
                                    height: 160
                                    radius: 80
                                    color: "transparent"
                                    border.color: Colors.primary
                                    border.width: 6
                                    
                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 4
                                        Text { 
                                            text: {
                                                let m = Math.floor(GlobalStates.pomodoroTimeRemaining / 60);
                                                let s = GlobalStates.pomodoroTimeRemaining % 60;
                                                return (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
                                            }
                                            font.pixelSize: 40; font.family: Config.fontFamily; color: Colors.foreground; anchors.horizontalCenter: parent.horizontalCenter 
                                        }
                                        Text { text: "Focus"; font.pixelSize: 14; font.family: Config.fontFamily; color: Qt.alpha(Colors.foreground, 0.6); anchors.horizontalCenter: parent.horizontalCenter }
                                    }
                                }
                            }
                        }
                        
                        // Bottom Buttons
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16
                            
                            Item { Layout.fillWidth: true }
                            
                            Rectangle {
                                width: 100; height: 36; radius: 18; color: Colors.primary
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: GlobalStates.pomodoroRunning = !GlobalStates.pomodoroRunning
                                }
                                Text { anchors.centerIn: parent; text: GlobalStates.pomodoroRunning ? "Pause" : "Start"; font.pixelSize: 14; font.family: Config.fontFamily; font.bold: true; color: Colors.surface }
                            }
                            
                            Rectangle {
                                width: 100; height: 36; radius: 18; color: "transparent"
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        GlobalStates.pomodoroRunning = false;
                                        GlobalStates.pomodoroTimeRemaining = 25 * 60;
                                    }
                                }
                                Text { anchors.centerIn: parent; text: "Reset"; font.pixelSize: 14; font.family: Config.fontFamily; color: Qt.alpha(Colors.foreground, 0.7) }
                            }
                            
                            Item { Layout.fillWidth: true }
                        }
                    }
                }
            }
        }
    }
}
