import qs.modules
import qs.modules.common
import qs.modules.common.widgets
import qs.theme as Theme
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Item {
  id: root
  implicitWidth: Appearance.sizes.barWidth

  readonly property bool clockHovered: datetime.hovered
  readonly property bool monitorHovered: systeminfo.hovered
  readonly property real sysInfoCenter: botCluster.y + systeminfo.y + systeminfo.height / 2
  readonly property list<real> cpuHist: systeminfo.cpuHist
  readonly property list<real> memHist: systeminfo.memHist
  readonly property list<real> tempHist: systeminfo.tempHist
  readonly property string hoveredItem: systeminfo.hoveredItem

  Rectangle {
    id: background

    anchors.fill: parent

    color: Theme.Theme.background

    // Top
    ColumnLayout {
      id: topCluster
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.margins: 10
      spacing: 10

      Workspaces {}
    }

    // Mid
    ColumnLayout {
      id: midCluster
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.margins: 10
      spacing: 10

    }

    // Bottom
    ColumnLayout {
      id: botCluster
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.margins: 10
      spacing: 10

      SystemInfo {
        id: systeminfo
      }

      DateTime {
        id: datetime
      }
    }
  }
}
