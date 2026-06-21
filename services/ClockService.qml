pragma Singleton
import QtQuick
import QtQml

Item {
    id: root
    property string time: ""
    property string date: ""
    property int hours: 0
    property int minutes: 0

    function updateTime() {
        let d = new Date();
        // Zero-pad hours and minutes
        let h = d.getHours();
        let m = d.getMinutes();
        root.hours = h;
        root.minutes = m;
        root.time = (h < 10 ? "0" + h : h) + ":" + (m < 10 ? "0" + m : m);
        root.date = d.toLocaleDateString(Qt.locale(), "ddd, MMM d");
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateTime()
    }

    Component.onCompleted: {
        root.updateTime();
    }
}
