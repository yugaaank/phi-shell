import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
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
    
    // Bind to the global state for logical open
    property bool isOpen: GlobalStates.sidebarOpen
    
    // Window is visible if logically open or if animation is finishing
    visible: isOpen || animTimer.running
    
    Timer {
        id: animTimer
        interval: 400
    }
    
    onIsOpenChanged: {
        if (!isOpen) {
            animTimer.restart()
        }
    }
    
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
        
        // Add a backdrop fade effect
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: sidebar.isOpen ? 0.3 : 0.0
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        }
    }
    
    // The actual sidebar container
    Item {
        id: sidebarContainer
        width: 420
        anchors {
            top: parent.top
            bottom: parent.bottom
            topMargin: 40 + (Config.barMode === "floating" ? Config.barMargin : 0)
            bottomMargin: 16
        }
        
        // Slide in from right (parent.width + 20 to parent.width - width - 12)
        x: sidebar.isOpen ? parent.width - width - 12 : parent.width + 20
        
        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }
        
        StyledRect {
            anchors.fill: parent
            color: Colors.surface
            radius: Config.borderRadius
            border.color: Colors.surfaceBorder
            border.width: 1
            
            // Prevent clicks inside the sidebar from closing it
            MouseArea {
                anchors.fill: parent
                onClicked: {}
            }
            
            // --- Update Timers ---
            Process {
                command: ["bash", "-c", "while true; do uptime -p; sleep 60; done"]
                running: true
                stdout: SplitParser {
                    onRead: data => {
                        let up = data.trim();
                        if (up.startsWith("up ")) {
                            up = "Up " + up.substring(3);
                        }
                        up = up.replace(" hours", "h").replace(" minutes", "m").replace(",", "");
                        GlobalStates.uptime = up;
                    }
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
                    Layout.preferredHeight: 48
                    spacing: 12
                    
                    // Left Pill (Logo + Uptime)
                    Rectangle {
                        Layout.preferredHeight: 48
                        Layout.preferredWidth: Math.max(120, uptimeRow.implicitWidth + 32)
                        radius: height / 2
                        color: Qt.alpha(Colors.surfaceBorder, 0.15)
                        
                        Row {
                            id: uptimeRow
                            anchors.centerIn: parent
                            spacing: 12
                            
                            Text {
                                text: "󰣇" // Arch Linux icon
                                font.pixelSize: 18
                                color: Colors.foreground
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: GlobalStates.uptime
                                font.pixelSize: 13
                                font.bold: true
                                font.family: Config.fontFamily
                                color: Colors.foreground
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    
                    Item { Layout.fillWidth: true } // Spacer
                    
                    // Right Pill (Buttons)
                    Rectangle {
                        Layout.preferredHeight: 48
                        Layout.preferredWidth: rightButtonsRow.implicitWidth + 32
                        radius: height / 2
                        color: Qt.alpha(Colors.surfaceBorder, 0.15)
                        
                        Row {
                            id: rightButtonsRow
                            anchors.centerIn: parent
                            spacing: 16
                            
                            Repeater {
                                model: ["󰏫", "󰑐", "", "⏻"]
                                
                                Text {
                                    text: modelData
                                    font.pixelSize: 16
                                    color: Colors.foreground
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.margins: -8 // Expand hit area
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onEntered: parent.color = Colors.primary
                                        onExited: parent.color = Colors.foreground
                                        onClicked: {
                                            if (modelData === "") {
                                                GlobalStates.settingsOpen = !GlobalStates.settingsOpen;
                                                GlobalStates.sidebarOpen = false;
                                            } else if (modelData === "⏻") {
                                                Quickshell.execDetached(["bash", "-c", "wlogout || systemctl poweroff"]);
                                            } else if (modelData === "󰑐") {
                                                Quickshell.execDetached(["bash", "-c", "killall qs; sleep 0.5; qs -p ~/.config/myshell/shell.qml & disown"]);
                                            } else if (modelData === "󰏫") {
                                                // Edit icon mockup
                                                Quickshell.execDetached(["notify-send", "Edit toggles"]);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // --- Quick Settings Toggles Row (end-4 style) ---
                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    color: Qt.alpha(Colors.surface, 0.4)
                    radius: Config.borderRadius
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 12
                        
                        // Wifi Toggle
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            radius: height / 2
                            color: GlobalStates.wifiConnected ? Colors.primary : Qt.alpha(Colors.surfaceBorder, 0.3)
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Quickshell.execDetached(["nm-connection-editor"])
                            }
                            Text { anchors.centerIn: parent; text: GlobalStates.wifiConnected ? "󰖩" : "󰖪"; font.pixelSize: 20; color: GlobalStates.wifiConnected ? Colors.onPrimaryColor : Colors.foreground }
                        }
                        
                        // Bluetooth Toggle
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            radius: height / 2
                            color: GlobalStates.bluetoothConnected ? Colors.primary : Qt.alpha(Colors.surfaceBorder, 0.3)
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Quickshell.execDetached(["blueman-manager"])
                            }
                            Text { anchors.centerIn: parent; text: "󰂯"; font.pixelSize: 20; color: GlobalStates.bluetoothConnected ? Colors.onPrimaryColor : Colors.foreground }
                        }
                        
                        // Night Light Toggle
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            radius: height / 2
                            color: GlobalStates.nightLightOn ? Colors.primary : Qt.alpha(Colors.surfaceBorder, 0.3)
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: GlobalStates.nightLightOn = !GlobalStates.nightLightOn
                            }
                            Text { anchors.centerIn: parent; text: "󰖔"; font.pixelSize: 20; color: GlobalStates.nightLightOn ? Colors.onPrimaryColor : Colors.foreground }
                        }
                        
                        // Mic Toggle
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            radius: height / 2
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
                            Text { anchors.centerIn: parent; text: GlobalStates.micMuted ? "󰍭" : "󰍬"; font.pixelSize: 20; color: GlobalStates.micMuted ? Colors.foreground : Colors.onPrimaryColor }
                        }
                        
                        // Audio Toggle
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            radius: height / 2
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
                            Text { anchors.centerIn: parent; text: GlobalStates.audioMuted ? "󰖁" : "󰕾"; font.pixelSize: 20; color: GlobalStates.audioMuted ? Colors.foreground : Colors.onPrimaryColor }
                        }
                    }
                }
                
                // --- Notifications Placeholder ---
                StyledRect {
                    Layout.fillWidth: true
                    Layout.fillHeight: true // takes remaining space
                    color: Qt.alpha(Colors.surfaceBorder, 0.1)
                    radius: Config.borderRadius
                    
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
                
                // --- Calendar (end-4 style) ---
                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
                    color: Qt.alpha(Colors.surfaceBorder, 0.1)
                    radius: Config.borderRadius
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        // Calendar Header
                        RowLayout {
                            Layout.fillWidth: true
                            
                            Text {
                                text: {
                                    let d = new Date();
                                    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
                                    return months[d.getMonth()] + " " + d.getFullYear();
                                }
                                font.pixelSize: 18
                                font.bold: true
                                color: Colors.foreground
                                font.family: Config.fontFamily
                            }
                            
                            Item { Layout.fillWidth: true }
                            
                            Row {
                                spacing: 8
                                Rectangle { width: 32; height: 32; radius: 16; color: Qt.alpha(Colors.surfaceBorder, 0.4); Text { anchors.centerIn: parent; text: ""; color: Colors.foreground } }
                                Rectangle { width: 32; height: 32; radius: 16; color: Qt.alpha(Colors.surfaceBorder, 0.4); Text { anchors.centerIn: parent; text: ""; color: Colors.foreground } }
                            }
                        }
                        
                        // Calendar Grid Mockup
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 7
                            columnSpacing: 8
                            rowSpacing: 8
                            
                            Repeater {
                                model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                                Text { text: modelData; color: Qt.alpha(Colors.foreground, 0.5); font.pixelSize: 12; font.family: Config.fontFamily; horizontalAlignment: Text.AlignHCenter; Layout.fillWidth: true }
                            }
                            
                            Repeater {
                                model: 35
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: (index === 15) ? Colors.primary : "transparent"
                                    radius: height / 2
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: ((index % 30) + 1).toString()
                                        color: (index === 15) ? Colors.surface : Colors.foreground
                                        font.pixelSize: 14
                                        font.family: Config.fontFamily
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
