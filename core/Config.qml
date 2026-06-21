pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property string barMode: "floating"
    property int barMargin: 12
    property int dockIconSize: 48
    property int borderRadius: 16
    property string theme: "material-you"
    property string fontFamily: "Inter"
    property string wallpaperPath: ""
    property bool showBattery: true
    property string clockFormat: "hh:mm A"

    function loadData() {
        try {
            let content = fileView.text();
            if (!content || content.trim() === "") return;
            let data = JSON.parse(content);
            if (data.layout) {
                if (data.layout.barMode !== undefined) root.barMode = data.layout.barMode;
                if (data.layout.barMargin !== undefined) root.barMargin = data.layout.barMargin;
                if (data.layout.dockIconSize !== undefined) root.dockIconSize = data.layout.dockIconSize;
            }
            if (data.appearance) {
                if (data.appearance.borderRadius !== undefined) root.borderRadius = data.appearance.borderRadius;
                if (data.appearance.theme !== undefined) root.theme = data.appearance.theme;
                if (data.appearance.fontFamily !== undefined) root.fontFamily = data.appearance.fontFamily;
                if (data.appearance.wallpaperPath !== undefined && data.appearance.wallpaperPath !== root.wallpaperPath) {
                    root.wallpaperPath = data.appearance.wallpaperPath;
                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/myshell/scripts/extract_colors.sh " + root.wallpaperPath]);
                }
            }
            if (data.widgets) {
                if (data.widgets.showBattery !== undefined) root.showBattery = data.widgets.showBattery;
                if (data.widgets.clockFormat !== undefined) root.clockFormat = data.widgets.clockFormat;
            }
        } catch (e) {
            console.error("Failed to parse config.json: " + e);
        }
    }

    property FileView fileView: FileView {
        path: Quickshell.env("HOME") + "/.config/myshell/config.json"
        watchChanges: true
        onFileChanged: reload()
        onTextChanged: root.loadData()
    }

    Component.onCompleted: fileView.reload()
}
