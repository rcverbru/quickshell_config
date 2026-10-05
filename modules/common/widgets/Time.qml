import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme as Theme

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
