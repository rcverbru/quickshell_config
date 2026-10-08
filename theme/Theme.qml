pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme.common

Singleton {
  // Main colors
  readonly property color background: CatppuccinMocha.base
  readonly property color border: CatppuccinMocha.blue
  readonly property color widget: CatppuccinMocha.surface0
  readonly property color text: CatppuccinMocha.text
  readonly property color subText: CatppuccinMocha.subtext0

  // Statuses
  readonly property color good: CatppuccinMocha.green
  readonly property color mid: CatppuccinMocha.yellow
  readonly property color bad: CatppuccinMocha.red

  // Battery
  readonly property color battNormal: Battery.dustyGrape
  readonly property color battCharging: Battery.charging
  readonly property color battLow: Battery.low
  readonly property color battText: CatppuccinMocha.text
}
