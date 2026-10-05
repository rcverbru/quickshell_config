import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import qs.theme as Theme

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
