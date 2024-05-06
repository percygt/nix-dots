{mkAppsFloatCenter}: {
  window = {
    titlebar = false;
    border = 1;
    hideEdgeBorders = "smart";
    commands =
      (mkAppsFloatCenter
        {
          app_ids = [
            "org.gnome.Calculator"
            "org.gnome.Calendar"
            "org.gnome.Firmware"
            "org.gnome.Snapshot"
            "org.keepassxc.KeePassXC"
            "org.pipewire.Helvum"
            "btop"
            "yazi"
            "gnome-disk"
            "org.gnome.Nautilus"
            "org.gnome.Calculator"
            "page.codeberg.Imaginer.Imaginer"
            "com.github.finefindus.eyedropper"
            "io.github.dvlv.boxbuddyrs"
            "org.rncbc.qpwgraph"
            "qpwgraph"
            "virt-manager"
          ];
          classes = [
            "zoom"
          ];
        })
      ++ (mkAppsFloatCenter {
        titles = [
          "^Picture in picture$"
        ];
        command = ''floating enable, resize set width 600 px height 300 px, move position 830 px 565 px, sticky on'';
      })
      ++ (mkAppsFloatCenter {
        app_ids = [
          "wpa_gui"
          "pavucontrol"
          "\.?blueman-manager(-wrapped)?"
        ];
        w = 50;
        h = 50;
      })
      ++ [
        {
          command = ''blur enable'';
          criteria = {
            app_id = "yazi";
          };
        }
        {
          command = ''blur enable'';
          criteria = {
            app_id = "foot";
          };
        }
      ];
  };
}
