import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme as Theme
import qs.modules.dashboard

Rectangle {
  id: dashboard

  implicitWidth: content.implicitWidth + 16
  implicitHeight: content.implicitHeight + 32

  topRightRadius: 20
  bottomRightRadius: 20
  property bool hovered: false

  color: Theme.Theme.background

  RowLayout {
    id: content
    anchors.centerIn: parent
    spacing: 8

    Calendar {
      id: calendar

      Layout.alignment: Qt.AlignHCenter
    }

    Weather {
      id: weather

      Layout.alignment: Qt.AlignHCenter
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onEntered: dashboard.hovered = true
    onExited: dashboard.hovered = false
  }
}
