import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme as Theme

Column {
  id: dateContent
  spacing: -5

  property date date

  Text {
    text: Qt.formatDateTime(date, "MMM")
    font{
      family: Theme.Theme.font
      letterSpacing: -1
      pixelSize: 15
      weight: 600
    }
    color: Theme.Theme.text
    anchors.horizontalCenter: parent.horizontalCenter
  }

  Text {
    text: Qt.formatDateTime(date, "dd")
    font{
      family: Theme.Theme.font
      letterSpacing: -1
      pixelSize: 25
      weight: 600
    }
    color: Theme.Theme.text
    anchors.horizontalCenter: parent.horizontalCenter
  }

  Text {
    text: Qt.formatDateTime(date, "yyyy")
    font{
      family: Theme.Theme.font
      letterSpacing: -1
      pixelSize: 15
      weight: 600
    }
    color: Theme.Theme.text
    anchors.horizontalCenter: parent.horizontalCenter
  }
}
