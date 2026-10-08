import QtQuick
import qs.modules.common
import qs.theme as Theme
import QtQuick.Shapes

Shape {
  id: root

  property int radius: 20
  property color color: Theme.Theme.background
  property bool isTop: true
  property bool mirrored: false

  implicitWidth: radius
  implicitHeight: radius

  preferredRendererType: Shape.CurveRenderer

  transform: Scale {
    xScale: root.mirrored ? -1 : 1
    origin.x: root.radius / 2
    origin.y: 0
  }

  ShapePath {
    fillColor: root.color
    strokeColor: "transparent"

    startX: root.isTop ? root.radius : 0
    startY: root.isTop ? 0 : 0

    PathLine {
      x: 0
      y: root.isTop ? 0 : root.radius
    }

    PathLine {
      x: root.isTop ? 0 : root.radius
      y: root.isTop ? root.radius : root.radius
    }

    PathArc {
      x: root.isTop ? root.radius : 0
      y: root.isTop ? 0 : 0 
      radiusX: root.radius
      radiusY: root.radius
      direction: root.isTop ? PathArc.Clockwise : PathArc.Counterclockwise
    }
  }
}
