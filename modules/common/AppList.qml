import "root:/"
import "root:/modules/common"
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets

Rectangle {
  required property HyprlandMonitor monitor

  implicitWidth: windowList.implicitWidth + 20
  implicitHeight: windowList.implicitHeight + 20
  color: Appearance.colors.colLayer0
  radius: 8

  Column {
    id: windowList

    anchors {
      fill: parent
      margins: 10
    }
    spacing: 8

    Repeater {
      model: monitor?.activeWorkspace?.toplevels

      delegate: Column {
        required property HyprlandToplevel modelData

        Rectangle {
          implicitWidth: 300
          implicitHeight: 50
          radius: 5
          // color: "red"
          clip: true

          // ScreencopyView {
          //   anchors.fill: parent
          //   captureSource: modelData.wayland
          //   live: true
          // }   
          Text {
            anchors.centerIn: parent
            text: DesktopEntries.heuristicLookup(modelData.wayland?.appId ?? "")?.name ?? modelData.title
            wrapMode: Text.WordWrap
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
          }
        }
      }
    }
  }
}
// IpcHandler {
//   target: "applistview"
//
//   function toggle(): void {
//     GlobalStates.appListViewOpen = !GlobalStates.appListViewOpen;
//   }
//
//   function open(): void {
//     GlobalStates.appListViewOpen = true;
//   }
//
//   function close(): void {
//     GlobalStates.appListViewOpen = false;
//   }
// }
