import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import qs.theme as Theme

Rectangle {
  id: clock
  // color: Appearance.colors.colLayer0
  color: Theme.Theme.bttnbg
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

      Column {
        id: dateContent
        anchors.centerIn: parent
        spacing: -5

        Text {
          text: Qt.formatDateTime(systemClock.date, "yyyy")
          font{
            family: "SF Mono"
            letterSpacing: -1
            pixelSize: 15
            weight: 600
          }
          color: Theme.Theme.text
          anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
          text: Qt.formatDateTime(systemClock.date, "dd")
          font{
            family: "SF Mono"
            letterSpacing: -1
            pixelSize: 25
            weight: 600
          }
          color: Theme.Theme.text
          anchors.horizontalCenter: parent.horizontalCenter
        }
      }
    }

    Shape {
      id: separator
      Layout.fillWidth: true
      Layout.preferredHeight: 2 // Thickness of the separator line

      ShapePath {
        strokeColor: "#999999"
        strokeWidth: 2
        strokeStyle: ShapePath.SolidLine // Enables dashing

        startX: 0
        startY: separator.height / 2
        PathLine {
          x: separator.width
          y: separator.height / 2
        }
      }
    }

    // Bottom half: time
    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Column {
        id: timeContent
        anchors.centerIn: parent
        spacing: -5

        Text {
          text: Qt.formatDateTime(systemClock.date, "hh")
          font{
            family: "SF Mono"
            letterSpacing: -1
            pixelSize: 25
            weight: 600
          }
          color: Theme.Theme.text
          anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
          text: Qt.formatDateTime(systemClock.date, "mm:ss")
          font{
            family: "SF Mono"
            letterSpacing: -1
            pixelSize: 15
            weight: 600
          }
          color: Theme.Theme.text
          anchors.horizontalCenter: parent.horizontalCenter
        }
      }
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
