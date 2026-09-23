import "root:/modules/top-bar"
import "root:/modules/desktopview"
import "root:/modules/dockview"
import "root:/modules/applistview"
import QtQuick
import Quickshell

ShellRoot {
  id: root

  TopBar {}
  DesktopView {}
  AppListView {}
}
