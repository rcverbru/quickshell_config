pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme.common

Singleton {
  id: battery
  // Colorset
  readonly property color full: "#1E555C"
  readonly property color charging: "#157f1f"
  readonly property color low: "#F72C25"
  readonly property color text: "#BDD5EA"

  readonly property color burntTangerine: "#e70e02"
  readonly property color jungleTeal: "#4D9078"
  readonly property color mossGreen: "#5FAD56"
  readonly property color harvestOrange: "#EC7505"
  readonly property color carrotOrange: "#E89004"
  readonly property color turquoise: "#5DD9C1"
  readonly property color aquamarine: "#ACFCD9"
  readonly property color amethystSmoke: "#B084CC"
  readonly property color dustyGrape: "#665687"
  readonly property color darkAmethyst: "#190933"
}
