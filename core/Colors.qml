pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property string background: "#1e1e2e"
    property string foreground: "#cdd6f4"
    property string primary: "#cba6f7"
    property string secondary: "#f38ba8"
    property string surface: "#313244"
    property string surfaceBorder: "#45475a"

    function loadData() {
        try {
            let content = fileView.text();
            if (!content || content.trim() === "") return;
            let data = JSON.parse(content);
            if (data.background) root.background = data.background;
            if (data.foreground) root.foreground = data.foreground;
            if (data.primary) root.primary = data.primary;
            if (data.secondary) root.secondary = data.secondary;
            if (data.surface) root.surface = data.surface;
            if (data.surfaceBorder) root.surfaceBorder = data.surfaceBorder;
        } catch (e) {
            console.error("Failed to parse colors.json: " + e);
        }
    }

    property FileView fileView: FileView {
        path: Quickshell.env("HOME") + "/.config/myshell/colors.json"
        watchChanges: true
        onFileChanged: reload()
        onTextChanged: root.loadData()
    }

    Component.onCompleted: fileView.reload()
}
