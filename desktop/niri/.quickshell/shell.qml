
/*
 * Noctalia – made by https://github.com/noctalia-dev
 * Licensed under the MIT License.
 * Forks and modifications are allowed under the MIT License,
 * but proper credit must be given to the original author.
*/

// Qt & Quickshell Core
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Widgets

// Commons & Services
import qs.Commons
import qs.Services
import qs.Widgets

// Core Modules
import qs.Modules.Background
import qs.Modules.Dock
import qs.Modules.LockScreen
import qs.Modules.SessionMenu

// Bar & Bar Components
import qs.Modules.Bar
import qs.Modules.Bar.Extras
import qs.Modules.Bar.Bluetooth
import qs.Modules.Bar.Calendar

import qs.Modules.Bar.WiFi

// Panels & UI Components
import qs.Modules.ControlCenter
import qs.Modules.Launcher
import qs.Modules.Notification
import qs.Modules.OSD
import qs.Modules.Settings
import qs.Modules.Toast
import qs.Modules.Wallpaper

ShellRoot {
  id: shellRoot

  Background {}
  Overview {}
  ScreenCorners {}
  Bar {}
  // Dock {}

  Notification {
    id: notification
  }

  LockScreen {
    id: lockScreen
  }

  ToastOverlay {}

  // OSD overlays for volume and brightness
  OSD {
    id: volumeOSD
    objectName: "volumeOSD"
    osdType: OSD.Type.Volume
    onOsdShowing: brightnessOSD.hideOSD()
  }

  OSD {
    id: brightnessOSD
    objectName: "brightnessOSD"
    osdType: OSD.Type.Brightness
    onOsdShowing: volumeOSD.hideOSD()
  }

  // IPCService is treated as a service
  // but it's actually an Item that needs to exists in the shell.
  IPCService {}

  // ------------------------------
  // All the NPanels
  Launcher {
    id: launcherPanel
    objectName: "launcherPanel"
  }

  ControlCenterPanel {
    id: controlCenterPanel
    objectName: "controlCenterPanel"
  }

  CalendarPanel {
    id: calendarPanel
    objectName: "calendarPanel"
  }

  SettingsPanel {
    id: settingsPanel
    objectName: "settingsPanel"
  }

  NotificationHistoryPanel {
    id: notificationHistoryPanel
    objectName: "notificationHistoryPanel"
  }

  SessionMenu {
    id: sessionMenuPanel
    objectName: "sessionMenuPanel"
  }

  WiFiPanel {
    id: wifiPanel
    objectName: "wifiPanel"
  }

  BluetoothPanel {
    id: bluetoothPanel
    objectName: "bluetoothPanel"
  }

  WallpaperPanel {
    id: wallpaperPanel
    objectName: "wallpaperPanel"
  }

  Component.onCompleted: {
    // Save a ref. to our lockScreen so we can access it  easily
    PanelService.lockScreen = lockScreen
  }

  Connections {
    target: Quickshell
    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup()
    }
  }
}
