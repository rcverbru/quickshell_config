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
      id: leftCluster
      anchors.left: parent.left
      anchors.leftMargin: 6
      anchors.verticalCenter: parent.verticalTop
      width: parent.width
      spacing: 10


    }
  }
}
