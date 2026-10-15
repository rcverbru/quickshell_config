// modules/common/widgets/Graph.qml
import QtQuick
import QtQuick.Shapes
import qs.theme as Theme

Item {
  id: root
  property var values: []          // e.g. [12, 40, 33, ...], newest last
  property real maxValue: 100 
  property int historyLength: 30
  property color lineColor: Theme.Theme.accent

  implicitWidth: 200
  implicitHeight: 60

  Shape {
    anchors.fill: parent
    preferredRendererType: Shape.CurveRenderer
    ShapePath {
      strokeColor: root.lineColor
      strokeWidth: 2
      fillColor: "transparent"
      PathPolyline {
        path: root.values.map((v, i) => Qt.point(
          i * root.width / (root.historyLength - 1),     // spread across the width 
          root.height - (v / root.maxValue) * root.height // 0 at bottom, max at top
        ))
      }
    }
  }
}
