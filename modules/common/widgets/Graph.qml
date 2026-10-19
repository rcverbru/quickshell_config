// modules/common/widgets/Graph.qml
import QtQuick
import QtQuick.Shapes
import qs.theme as Theme

Item {
  id: root
  property var values: []
  property real maxValue: 100 
  property int historyLength: 30
  property color lineColor: Theme.Theme.accent
  property string title: ""

  implicitWidth: 200
  implicitHeight: 100

  Text {
    id: title

    font {
      family: Theme.Theme.font
      pixelSize: 12
    }

    anchors.horizontalCenter: parent.horizontalCenter
    color: Theme.Theme.text
    text: root.title
  }

  Rectangle {
    id: graph
    anchors.top: title.bottom
    anchors.topMargin: 4
    anchors.horizontalCenter: parent.horizontalCenter

    implicitWidth: 200
    implicitHeight: 80
    radius: 10

    color: "transparent"
    border.color: Theme.Theme.background
    border.width: 2

    Shape {
      id: plot
      anchors.fill: parent
      anchors.margins: graph.border.width + 2
      preferredRendererType: Shape.CurveRenderer
      ShapePath {
        strokeColor: root.lineColor
        strokeWidth: 2
        fillColor: "transparent"
        PathPolyline {
          path: root.values.map((v, i) => Qt.point(
            i * plot.width / (root.historyLength - 1),
            plot.height - (v / root.maxValue) * plot.height
          ))
        }
      }
    }
  }
}
