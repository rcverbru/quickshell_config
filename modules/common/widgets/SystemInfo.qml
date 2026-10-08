import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.theme as Theme

ColumnLayout {
  id: root
  spacing: 8

  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 15
  property real cpuUsage: 0
  property real ramUsage: 0
  property int cpuTemp: 0

  Process {
    id: sysInfoProc
    command: ["bash", "-c",
      "read -r _ u1 n1 s1 i1 w1 ir1 soft1 st1 _ < /proc/stat; " +
      "sleep 0.5; " +
      "read -r _ u2 n2 s2 i2 w2 ir2 soft2 st2 _ < /proc/stat; " +
      "tot1=$((u1+n1+s1+i1+w1+ir1+soft1+st1)); tot2=$((u2+n2+s2+i2+w2+ir2+soft2+st2)); " +
      "idle1=$((i1+w1)); idle2=$((i2+w2)); " +
      "cpu=$(awk -v t1=$tot1 -v t2=$tot2 -v i1=$idle1 -v i2=$idle2 'BEGIN { dt=t2-t1; didle=i2-i1; print (dt>0) ? sprintf(\"%.0f\", 100*(dt-didle)/dt) : 0 }'); " +
      "mem=$(free | awk '/Mem:/{printf \"%d\", $3/$2*100}'); " +
      "temp=$(sensors 2>/dev/null | awk '/Package id 0:/ {print $4}' | tr -dc '0-9.' | awk '{print int($1)}'); " +
      "echo \"$cpu $mem ${temp:-0}\""
    ]
    stdout: SplitParser {
      onRead: data => {
        const parts = data.trim().split(/\s+/);
        if (parts.length === 3) {
          root.cpuUsage = parseInt(parts[0]) || 0;
          root.ramUsage = parseInt(parts[1]) || 0;
          root.cpuTemp = parseInt(parts[2]) || 0;
        }
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: sysInfoProc.running = true
  }

  Rectangle {
    //Temp
    id: systemp
    radius: 15
    color: Theme.Theme.widget

    property bool hovered: false
    property bool pressed: false

    implicitWidth: 70
    implicitHeight: implicitWidth
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: width / 2
    
    scale: pressed ? 0.985 : (systemp.hovered ? 1.05 : 1.0)
    Behavior on scale {
      NumberAnimation { duration: 90; easing.type: Easing.OutQuad }
    }

    Row {
      anchors.centerIn: parent
      spacing: 6

      Text {
        text: String.fromCodePoint(0xF050F)
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        color: Theme.Theme.text
        anchors.verticalCenter: parent.verticalCenter
      }

      Text { 
        text: root.cpuTemp + "°"
        font {
          family: "SF Mono"
          pixelSize: root.fontSize
          weight: 600
        }
        color: { 
          if (root.cpuTemp >= 80) return Theme.Theme.bad;
          if (root.cpuTemp >= 66) return Theme.Theme.mid;
          return Theme.Theme.good;
        } 
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onEntered: systemp.hovered = true
      onExited: systemp.hovered = false
    }
  }

  Rectangle {
    // cpu
    id: cpuinfo
    radius: 15
    color: Theme.Theme.widget

    property bool hovered: false
    property bool pressed: false

    implicitWidth: 70
    implicitHeight: implicitWidth
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: width / 2

    scale: pressed ? 0.985 : (cpuinfo.hovered ? 1.05 : 1.0)
    Behavior on scale {
      NumberAnimation { duration: 90; easing.type: Easing.OutQuad }
    }

    Row {
      anchors.centerIn: parent
      spacing: 6

      Text {
        text: String.fromCodePoint(0xF0EE0)
        font.family: root.fontFamily
        font.pixelSize: root.fontSize + 1
        color: Theme.Theme.text
        anchors.verticalCenter: parent.verticalCenter
      }

      Text { 
        text: root.cpuUsage + "%"
        font {
          family: "SF Mono"
          pixelSize: root.fontSize
          weight: 600
        }
        color: { 
          if (root.cpuUsage >= 80) return Theme.Theme.bad;
          if (root.cpuUsage >= 60) return Theme.Theme.mid;
          return Theme.Theme.good;
        } 
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onEntered: cpuinfo.hovered = true
      onExited: cpuinfo.hovered = false
    }
  }

  Rectangle {
    // mem
    id: memusage
    radius: 15
    color: Theme.Theme.widget

    property bool hovered: false
    property bool pressed: false

    implicitWidth: 70
    implicitHeight: implicitWidth
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    Layout.preferredHeight: width / 2

    scale: pressed ? 0.985 : (memusage.hovered ? 1.05 : 1.0)
    Behavior on scale {
      NumberAnimation { duration: 90; easing.type: Easing.OutQuad }
    }

    Row {
      anchors.centerIn: parent
      spacing: 6

      Text {
        text: String.fromCodePoint(0xF035B)
        font.family: root.fontFamily
        font.pixelSize: root.fontSize + 1
        color: Theme.Theme.text
        anchors.verticalCenter: parent.verticalCenter
      }

      Text { 
        text: root.ramUsage + "%"
        font {
          family: "SF Mono"
          pixelSize: root.fontSize
          weight: 600
        }
        color: { 
          if (root.ramUsage >= 80) return Theme.Theme.bad;
          if (root.ramUsage >= 60) return Theme.Theme.mid;
          return Theme.Theme.good;
        } 
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onEntered: memusage.hovered = true
      onExited: memusage.hovered = false
    }
  }
}
