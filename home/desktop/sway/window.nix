{mkAppsFloat}: {
  window = {
    titlebar = false;
    border = 1;
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
            "brave-chatgpt.com__-WebApp-ai"
            "brave-app.zoom.us__wc-WebApp-zoom"
          ];
          classes = [
            "zoom"
          ];
        })
      ++ (mkAppsFloat {
        titles = ["^Picture in picture$"];
        command = ''floating enable, resize set width 25ppt height 25ppt, move position 50ppt 100ppt, sticky on'';
      })
      ++ (mkAppsFloat {
        w = 50;
        h = 50;
        app_ids = ["wpa_gui" "pavucontrol" "\.?blueman-manager(-wrapped)?"];
      })
      ++ (mkAppsFloat {
        titles = [".*"];
        command = ''inhibit_idle fullscreen'';
      })
      ++ [
        {
          command = ''blur enable'';
          criteria = {
            app_id = "foot";
          };
        }
      ];
  };
}
