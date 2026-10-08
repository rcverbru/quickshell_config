import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Networking
import qs.theme as Theme

Item {
  id: root

  implicitHeight: 28
  implicitWidth: bg.implicitWidth

  property color bgColor: Theme.Theme.bttnbg
  property color textColor: Theme.Theme.battText

  property bool connectionFound: false
  property string connectionType: "Unknown"

}
