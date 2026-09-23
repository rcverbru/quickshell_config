import "root:/modules/common"
import "root:/modules/common/widgets"
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: Appearance.sizes.barHeight
            color: Appearance.colors.colLayer0

            WlrLayershell.namespace: "quickshell:bar"
            WlrLayershell.layer: WlrLayer.Top

            SystemClock {
                id: clock
                precision: SystemClock.Seconds
            }

            StyledText {
                anchors.centerIn: parent
                text: Qt.formatDateTime(clock.date, "hh:mm:ss  -  ddd, MMM d")
            }
        }
    }
}
