// Quickshell searches the quickshell subfolder of every XDG standard config path for configs. Usually, this is ~/.config/quickshell.
//
// Each named subfolder containing a shell.qml file is considered to be a config. If the base quickshell folder contains a shell.qml file, subfolders will not be considered.
import Quickshell 
import QtQuick
PanelWindow {
  anchors {
    top: true 
    left: true
    right: true
  }
  implicitHeight: 30
  Text {
    id: clock
    anchors.centerIn: parent

    Process {
      // give the process object an id so we can talk
      // about it from the timer
      id: dateProc

      command: ["date"]
      running: true

      stdout: StdioCollector {
        onStreamFinished: clock.text = this.text
      }
    }

    // use a timer to rerun the process at an interval
    Timer {
      // 1000 milliseconds is 1 second
      interval: 1000

      // start the timer immediately
      running: true

      // run the timer again when it ends
      repeat: true

      // when the timer is triggered, set the running property of the
      // process to true, which reruns it if stopped.
      onTriggered: dateProc.running = true
    }
  }
}
