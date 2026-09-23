import qs
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets

Scope {
  id: desktopViewScope

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: root
      required property var modelData
      readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.screen)

      screen: modelData
      visible: GlobalStates.desktopViewOpen

      WlrLayershell.namespace: "quickshell:desktopview"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }

      color: "transparent"

      Image {
        anchors.fill: parent
        source: Directories.config + "/hypr/rofi/.current_wallpaper_" + (root.monitor?.name ?? "")
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
          if (status === Image.Error) source = Appearance.background_image;
        }
      }

      AppList {
        anchors {
          left: parent.left
          verticalCenter: parent.verticalCenter
        }
        monitor: root.monitor
      }

      MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.desktopViewOpen = false
      }
    }
  }

  IpcHandler {
    target: "desktopview"

    function toggle(): void {
      GlobalStates.desktopViewOpen = !GlobalStates.desktopViewOpen;
    }

    function open(): void {
      GlobalStates.desktopViewOpen = true;
    }

    function close(): void {
      GlobalStates.desktopViewOpen = false;
    }
  }
}
