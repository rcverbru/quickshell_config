import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import qs.theme as Theme
import qs.modules.common.visual

Rectangle {
  id: clock
  // color: Appearance.colors.colLayer0
  color: Theme.Theme.widget
  radius: 15

  implicitWidth: 70
  implicitHeight: implicitWidth * 2
  Layout.fillWidth: true
  Layout.alignment: Qt.AlignHCenter
  Layout.preferredHeight: width * 2

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
    anchors.fill: parent
    anchors.margins: 8 // keeps content + separator off the rounded edges
    spacing: 0

    // Top half: date
    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true // both halves fill → equal heights

      Date {}
    }

    Separator {}

    // Bottom half: time
    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Time {}
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onEntered: clock.hovered = true
    onExited: clock.hovered = false
  }
}
