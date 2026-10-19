pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme.common

Singleton {
  readonly property string font: "JetBrainsMono Nerd Font"

  // Main colors
  readonly property color background: CatppuccinMocha.base
  readonly property color border: CatppuccinMocha.blue
  readonly property color widget: CatppuccinMocha.surface0
  readonly property color text: CatppuccinMocha.text
  readonly property color subText: CatppuccinMocha.subtext0
  readonly property color accent: CatppuccinMocha.lavender

  readonly property color active: CatppuccinMocha.mauve
  readonly property color available: CatppuccinMocha.blue

  // Statuses
  readonly property color good: CatppuccinMocha.green
  readonly property color mid: CatppuccinMocha.yellow
  readonly property color bad: CatppuccinMocha.red

  // Battery
  readonly property color battNormal: CatppuccinMocha.green
  readonly property color battCharging: CatppuccinMocha.green
  readonly property color battLow: CatppuccinMocha.red
  readonly property color battText: CatppuccinMocha.base
}
