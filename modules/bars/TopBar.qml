import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Item {
  id: root
  implicitHeight: Appearance.sizes.barHeight

  Rectangle {
    id: background

    anchors.fill: parent

    color: Appearance.colors.colLayer0

    // Left
    RowLayout {
      id: leftCluster
      anchors.left: parent.left
      anchors.leftMargin: 6
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height
      spacing: 10

      DateTime { Layout.alignment: Qt.AlignVCenter }
      Battery  { Layout.alignment: Qt.AlignVCenter }
    }

    // Center
    RowLayout {
      id: centerCluster
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height
      spacing: 6

      SystemClock {
        id: clock
        precision: SystemClock.Seconds
      }
      StyledText {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "hh:mm:ss  -  ddd, MMM d")
      }
      // readonly property real sideW: Math.max(leftContent.implicitWidth, rightContent.implicitWidth)
      //
      // Item {
      //     Layout.preferredWidth: centerCluster.sideW
      //     Layout.minimumWidth: centerCluster.sideW
      //     Layout.fillHeight: true
      //     Layout.alignment: Qt.AlignVCenter
      //
      //     Row {
      //         id: leftContent
      //         anchors.right: parent.right
      //         anchors.verticalCenter: parent.verticalCenter
      //         spacing: 6
      //
      //         Memory {}
      //         Temperature {}
      //
      //         Power {
      //             powerIcon:    Qt.resolvedUrl("../assets/power_icons/power-1.svg")
      //             lockIcon:     Qt.resolvedUrl("../assets/power_icons/lock.svg")
      //             sleepIcon:    Qt.resolvedUrl("../assets/power_icons/moon.svg")
      //             logoutIcon:   Qt.resolvedUrl("../assets/power_icons/log-out.svg")
      //             rebootIcon:   Qt.resolvedUrl("../assets/power_icons/refresh-cw.svg")
      //             shutdownIcon: Qt.resolvedUrl("../assets/power_icons/power.svg")
      //         }
      //     }
      // }
      //
      // Workspaces { Layout.alignment: Qt.AlignVCenter }
      //
      // Item {
      //     Layout.preferredWidth: centerCluster.sideW
      //     Layout.minimumWidth: centerCluster.sideW
      //     Layout.fillHeight: true
      //     Layout.alignment: Qt.AlignVCenter
      //
      //     Row {
      //         id: rightContent
      //         anchors.left: parent.left
      //         anchors.verticalCenter: parent.verticalCenter
      //         spacing: 6
      //
      //         Mediaplayer { id: media }
      //     }
      // }
    }

    RowLayout {
      id: rightCluster
      anchors.right: parent.right
      anchors.rightMargin: 6
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height
      spacing: 6

      // RightBtn { Layout.alignment: Qt.AlignVCenter }
    }
  }
}
