import qs.modules.common
import qs.modules.common.widgets
import qs.modules.bars
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData
      mask: Region{
        Region { item: topBar }
        Region { item: sideBar }
      }

      anchors {
        top: true
        left: true
        right: true
        bottom: true
      }

      implicitHeight: Appearance.sizes.barHeight
      color: "transparent"

      WlrLayershell.namespace: "quickshell:bar"
      WlrLayershell.layer: WlrLayer.Top
      WlrLayershell.exclusionMode: ExclusionMode.Ignore

      TopBar {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
      }
      SideBar { 
        id: sideBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
      }
    }
  }
}

