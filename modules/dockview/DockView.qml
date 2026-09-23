import qs
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
  id: dockViewScope

  Variants {
    model: Quickshell.screens

    FloatingWindow {
      id: root

      WlrLayershell.namespace: "quickshell:dockview"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      color: "transparent"

      

    }
  }

  IpcHandler {
    target: "dockview"

    function toggle(): void {
      GlobalStates.dockViewOpen = !GlobalStates.dockViewOpen;
    }

    function open(): void {
      GlobalStates.dockViewOpen = true;
    }

    function close(): void {
      GlobalStates.dockViewOpen = false;
    }
  }
}
