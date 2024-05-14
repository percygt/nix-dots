{mkAppsFloat}: {
  window = {
    titlebar = false;
    border = 1;
    commands =
      (mkAppsFloat
        {
          app_ids = [
            "xdg-desktop-portal-gtk"
            "org.gnome.Calculator"
            "org.telegram.desktop"
            "org.gnome.Calendar"
            "org.gnome.Firmware"
            "org.gnome.Snapshot"
            "org.keepassxc.KeePassXC"
            "org.pipewire.Helvum"
            "btop"
            "yazi"
            "gnome-disk"
            "org.gnome.Calculator"
            "page.codeberg.Imaginer.Imaginer"
            "com.github.finefindus.eyedropper"
            "org.gnome.Nautilus"
            "io.github.dvlv.boxbuddyrs"
            "com.github.johnfactotum.Foliate"
            "virt-manager"
            "brave-chatgpt.com__-WebApp-ai"
            "brave-app.zoom.us__wc-WebApp-zoom"
            "nemo"
          ];
          classes = [
            "zoom"
          ];
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
          command = ''floating enable, resize set width 75ppt height 75ppt, move position center'';
          criteria = {
            title = "^Brave$";
          };
        }
        {
          command = ''floating enable, resize set width 15ppt height 15ppt, move position 50ppt 100ppt, sticky on'';
          criteria = {
            title = "^Picture in picture$";
          };
        }
      ];
  };
}
