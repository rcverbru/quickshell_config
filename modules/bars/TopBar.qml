import qs.modules.common
import qs.modules.common.widgets
import qs.theme as Theme
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Networking

Item {
  id: root
  implicitHeight: Appearance.sizes.barHeight

  Rectangle {
    id: background

    anchors.fill: parent

    color: Theme.Theme.background

    // Left
    RowLayout {
      id: leftCluster
      anchors.left: parent.left
      anchors.leftMargin: 6
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height
      spacing: 10

    }

    // Center
    RowLayout {
      id: centerCluster
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height
      spacing: 6

    }

    RowLayout {
      id: rightCluster
      anchors.right: parent.right
      anchors.rightMargin: 6
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height
      spacing: 6

      // RightBtn { Layout.alignment: Qt.AlignVCenter }
      Battery  { Layout.alignment: Qt.AlignVCenter }
    }
  }
}
