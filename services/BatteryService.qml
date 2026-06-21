pragma Singleton
import QtQuick
import Quickshell.Services.UPower

QtObject {
    id: root
    
    readonly property var primaryDevice: {
        if (UPower.displayDevice && UPower.displayDevice.isPresent) {
            return UPower.displayDevice;
        }
        let devices = UPower.devices ? UPower.devices.values : [];
        for (let i = 0; i < devices.length; i++) {
            if (devices[i] && devices[i].type === UPowerDeviceType.Battery) {
                return devices[i];
            }
        }
        return null;
    }
    
    readonly property real percent: primaryDevice ? Math.round((primaryDevice.percentage || 0) * 100) : 0
    readonly property bool isCharging: primaryDevice ? primaryDevice.state === UPowerDeviceState.Charging : false
    readonly property bool isPluggedIn: primaryDevice ? (primaryDevice.state === UPowerDeviceState.Charging || primaryDevice.state === UPowerDeviceState.FullyCharged) : false
    readonly property bool isReady: primaryDevice !== null

    function getIcon() {
        if (!isReady) return "battery-missing-symbolic";
        let p = percent;
        if (isCharging) {
            if (p >= 90) return "battery-charging-100-symbolic";
            if (p >= 60) return "battery-charging-80-symbolic";
            if (p >= 40) return "battery-charging-60-symbolic";
            if (p >= 20) return "battery-charging-40-symbolic";
            return "battery-charging-20-symbolic";
        } else {
            if (p >= 90) return "battery-100-symbolic";
            if (p >= 60) return "battery-80-symbolic";
            if (p >= 40) return "battery-60-symbolic";
            if (p >= 20) return "battery-40-symbolic";
            if (p >= 10) return "battery-20-symbolic";
            return "battery-empty-symbolic";
        }
    }

    readonly property string icon: getIcon()
}
