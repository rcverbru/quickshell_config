import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme as Theme

Rectangle {
    id: clock
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
            text: Qt.formatDateTime(systemClock.date, "hh")
            fontSizeMode: Text.Fit
            minimumPointSize: 20
            // font.pointSize: 20
            font{
              pixelSize: 20
              weight: Font.Bold
            }
            color: Theme.Theme.text
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
          text: Qt.formatDateTime(systemClock.date, "mm:ss")
            fontSizeMode: Text.Fit
            minimumPointSize: 10
            // font.pointSize: 20
            font{
              pixelSize: 15
              weight: Font.Bold
            }
            color: Theme.Theme.text
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

