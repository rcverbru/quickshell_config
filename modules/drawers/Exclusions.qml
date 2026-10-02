import QtQuick
import Quickshell
// import Caelestia.Config
// import qs.components.containers
import Quickshell.Wayland
import qs.modules.common

Scope {
  id: root

  required property ShellScreen screen
  // required property Bar.BarWrapper bar

  ExclusionZone {
    anchors.left: true
    exclusiveZone: Appearance.sizes.barWidth
  }

  ExclusionZone {
    anchors.top: true
    exclusiveZone: Appearance.sizes.barHeight
  }

  // ExclusionZone {
  //   anchors.right: true
  // }
  //
  // ExclusionZone {
  //   anchors.bottom: true
  // }

  component ExclusionZone: PanelWindow {
    screen: root.screen
    // name: "border-exclusion"
    WlrLayershell.namespace: "quickshell:exclusion"
    // exclusiveZone: contentItem.Config.border.thickness
    mask: Region {}
    color: "transparent"
    implicitWidth: 1
    implicitHeight: 1
  }
}
