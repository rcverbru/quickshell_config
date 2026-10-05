import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Item {
  id: root
  implicitWidth: Appearance.sizes.barWidth

  Rectangle {
    id: background

    anchors.fill: parent

    color: Appearance.colors.colLayer0

    // Top
    ColumnLayout {
      id: topCluster
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.margins: 10
      spacing: 10

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

      // Battery {
      //   anchors.horizontalCenter: parent.horizontalCenter
      // }
      Clock {}
    }
  }
}
