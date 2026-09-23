import "root:/"
import "root:/modules/common"
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
  id: appListViewScope

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: root
      required property var modelData
      readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.screen)

      screen: modelData
      visible: GlobalStates.appListOpen

      WlrLayershell.namespace: "quickshell:applistview"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }

      color: "transparent"

      AppList {
        anchors.centerIn: parent
        monitor: root.monitor
      }

      MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.appListOpen = false
      }
    }
  }

  IpcHandler {
    target: "applist"

    function toggle(): void {
      GlobalStates.appListOpen = !GlobalStates.appListOpen;
    }

    function open(): void {
      GlobalStates.appListOpen = true;
    }

    function close(): void {
      GlobalStates.appListOpen = false;
    }
  }
}
