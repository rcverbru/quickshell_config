import QtQuick
import Quickshell
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
    property bool overviewOpen: false
    property bool desktopViewOpen: false
    property bool appListOpen: false
}
