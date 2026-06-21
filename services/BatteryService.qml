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
        if (!isReady) return "󰂑"; // missing
        let p = percent;
        if (isCharging) {
            if (p >= 90) return "󰂅";
            if (p >= 80) return "󰂋";
            if (p >= 60) return "󰢞";
            if (p >= 40) return "󰢝";
            if (p >= 20) return "󰂇";
            return "󰢜";
        } else {
            if (p >= 90) return "󰁹";
            if (p >= 80) return "󰂁";
            if (p >= 60) return "󰁿";
            if (p >= 40) return "󰁽";
            if (p >= 20) return "󰁻";
            if (p >= 10) return "󰁺";
            return "󰂎";
        }
    }

    readonly property string icon: getIcon()
}
