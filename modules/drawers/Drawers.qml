import qs.modules.common
import qs.modules.common.widgets
import qs.modules.bars
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

        MouseArea {
          anchors.fill: parent
          onClicked: {
            isLeftMost(scope.modelData.name)
          }
        }
      }
      ConcaveCurves {
        anchors.top: topBar.bottom
        anchors.left: sideBar.right
        radius: 16
        isTop: true
        z: 1
      }
    }
  }

  function isLeftMost(monitors: list): void {
    console.log("Monitors: " + monitors);
  }
}

