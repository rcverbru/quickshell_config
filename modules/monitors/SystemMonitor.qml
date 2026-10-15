import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme as Theme
import qs.modules.common.widgets

Rectangle {
  id: monitors

  property bool hovered: false
  property bool open: false
  // cpuHistory = [...cpuHistory, cpuUsage].slice(-30)   // add newest, keep

  clip: true                                         // hide the contents while it's short
  implicitWidth: open ? content.implicitWidth + 32 : 0
  Behavior on implicitWidth { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

  implicitHeight: content.implicitHeight + 32

  topRightRadius: 20
  bottomRightRadius: 20

  color: Theme.Theme.background

  ColumnLayout {
    id: content
    anchors.centerIn: parent
    spacing: 8

    Graph {
      id: cpugraph

      values: sideBar.cpuHist
    }
    Graph {
      id: memgraph

      values: sideBar.memHist
    }
    Graph {
      id: tempgraph

      values: sideBar.tempHist
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onEntered: monitors.hovered = true
    onExited: monitors.hovered = false
  }
}
