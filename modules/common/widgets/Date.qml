import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme as Theme

Rectangle {
  id: date
  // color: Appearance.colors.colLayer0
  color: Theme.Theme.bttnbg
  radius: 15

  implicitWidth: 70
  implicitHeight: content.implicitHeight + 16
  Layout.fillWidth: true
  Layout.alignment: Qt.AlignHCenter
  Layout.preferredHeight: width

  SystemClock {
    id: systemClock
    precision: SystemClock.Seconds
  }

  Column {
    id: content
    anchors.centerIn: parent
    spacing: -5

    Text {
      text: Qt.formatDateTime(systemClock.date, "yyyy")
      fontSizeMode: Text.Fit
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
      fontSizeMode: Text.Fit
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

