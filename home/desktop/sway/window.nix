{mkAppsFloat}: {
  window = {
    titlebar = false;
    border = 1;
    hideEdgeBorders = "smart";
    commands =
      (mkAppsFloat
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
      ++ (mkAppsFloat {
        titles = ["^Picture in picture$"];
        command = ''floating enable, resize set width 600 px height 300 px, move position 830 px 565 px, sticky on'';
      })
      ++ (mkAppsFloat {
        app_ids = ["wpa_gui" "pavucontrol" "\.?blueman-manager(-wrapped)?"];
        command = ''floating enable, resize set width 50ppt height 50ppt, move position 50ppt 0'';
      })
      ++ (mkAppsFloat {
        titles = [".*"];
        command = ''move position center, inhibit_idle fullscreen'';
      })
      ++ [
        {
          command = ''move position center'';
          criteria = {
            app_id = "org.gnome.Nautilus";
            title = "";
          };
        }
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
