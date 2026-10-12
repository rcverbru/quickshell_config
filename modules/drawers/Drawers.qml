import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.visual
import qs.modules.bars
import qs.modules.dashboard
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Variants {
  model: Quickshell.screens

  Scope {
    id: scope
    required property var modelData
    Exclusions {
      screen: scope.modelData
    }

    PanelWindow {
      screen: scope.modelData

      mask: Region{
        Region { item: topBar }
        Region { item: sideBar }
        Region { item: dashboard.visible ? dashboard : null }
      }

      anchors {
        top: true
        left: true
        right: true
        bottom: true
      }

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
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
      }

      ConcaveCurves {
        anchors.top: topBar.bottom
        anchors.left: sideBar.right
        radius: 20
        isTop: true
        z: 1
      }

      Dashboard {
        id: dashboard
        visible: sideBar.clockHovered || dashboard.hovered
        anchors.bottom: parent.bottom
        anchors.left: sideBar.right
      } 

      ConcaveCurves {
        anchors.bottom: dashboard.top
        anchors.left: sideBar.right
        visible: dashboard.visible
        radius: 20
        isTop: false
        z: 1
      }
    }
  }
}

