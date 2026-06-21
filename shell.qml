import QtQuick
import Quickshell
import Quickshell.Wayland
import "core"
import "modules/bar"
import "modules/dock"
import "modules/desktop"

import "modules/popups"

ShellRoot {
    id: root
    
    Desktop {}
    TopBar {}
    Dock {}
    AppLauncher {}
}
