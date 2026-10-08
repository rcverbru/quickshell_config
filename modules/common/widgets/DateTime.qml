import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import qs.theme as Theme
import qs.modules.common.visual

Rectangle {
  id: clock
  color: Theme.Theme.widget
  radius: 15

  implicitWidth: 70
  implicitHeight: content.implicitHeight + 16
  Layout.fillWidth: true

  property bool hovered: false
  property bool pressed: false

  scale: pressed ? 0.985 : (clock.hovered ? 1.03 : 1.0)
  Behavior on scale {
    NumberAnimation { duration: 90; easing.type: Easing.OutQuad }
  }

  SystemClock {
    id: systemClock
    precision: SystemClock.Seconds
  }

  ColumnLayout {
    id: content
    anchors.fill: parent
    anchors.margins: 8 // keeps content + separator off the rounded edges
    spacing: 6

    Date { 
      date: systemClock.date
      Layout.alignment: Qt.AlignHCenter
    }

    Separator {}

    Time { Layout.alignment: Qt.AlignHCenter }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onEntered: clock.hovered = true
    onExited: clock.hovered = false
  }
}
