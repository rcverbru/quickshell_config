import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme as Theme
import qs.modules.common.widgets

Rectangle {
  id: monitors

  property bool hovered: false
  property bool open: false

  property list<real> cpuHist: []
  property list<real> memHist: []
  property list<real> tempHist: []
  property string hoveredItem

  clip: true
  implicitWidth: open ? content.implicitWidth + 32 : 0
  Behavior on implicitWidth { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

  implicitHeight: content.implicitHeight + 32

  topRightRadius: 20
  bottomRightRadius: 20

  color: Theme.Theme.background

  Rectangle {
    radius: 20

    implicitHeight: content.implicitHeight + 16
    implicitWidth: content.implicitWidth + 16
    color: Theme.Theme.widget
    anchors.centerIn: parent

    ColumnLayout {
      id: content
      anchors.centerIn: parent
      spacing: 8

      Graph {
        id: cpugraph
        visible: hoveredItem === "cpu" ? true : false

        title: "CPU Usage"
        values: monitors.cpuHist
      }
      Graph {
        id: memgraph
        visible: hoveredItem === "memory" ? true : false

        title: "Memory Usage"
        values: monitors.memHist
      }
      Graph {
        id: tempgraph
        visible: hoveredItem === "temp" ? true : false

        title: "CPU Temperature (°C)"
        values: monitors.tempHist
      }
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
