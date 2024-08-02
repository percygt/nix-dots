{ mkAppsFloat }:
{
  window = {
    titlebar = false;
    border = 1;
    commands =
      (mkAppsFloat {
        app_ids = [
          "xdg-desktop-portal-gtk"
          "org.gnome.Calculator"
          "org.telegram.desktop"
          "org.gnome.Calendar"
          "org.gnome.Firmware"
          "org.gnome.Snapshot"
          "org.gnome.Loupe"
          "org.keepassxc.KeePassXC"
          "btop"
          "yazi"
          "system-software-update"
          "page.codeberg.Imaginer.Imaginer"
          "com.github.finefindus.eyedropper"
          "org.gnome.Nautilus"
          "io.github.dvlv.boxbuddyrs"
          "com.github.johnfactotum.Foliate"
          "brave-chatgpt.com__-WebApp-ai"
          "brave-app.zoom.us__wc-WebApp-zoom"
          "io.bassi.Amberol"
          "qalculate-gtk"
          "info.mumble.Mumble"
        ];
      })
      ++ (mkAppsFloat {
        w = 50;
        h = 50;
        app_ids = [
          "wpa_gui"
          "udiskie"
          "pavucontrol"
          "\.?blueman-manager(-wrapped)?"
        ];
      })
      ++ (mkAppsFloat {
        titles = [ ".*" ];
        command = ''inhibit_idle fullscreen'';
      })
      ++ (mkAppsFloat {
        classes = [
          "\.?qemu-system-x86_64(-wrapped)?"
          "Spotify"
        ];
      })
      ++ [
        # {
        #   command = ''floating enable, resize set width 100ppt height 100ppt, move position center'';
        #   criteria = {
        #     app_id = "foot";
        #   };
        # }
        {
          command = ''floating enable, resize set width 100ppt height 100ppt, move position center'';
          criteria = {
            app_id = "emacs";
          };
        }
        {
          command = ''floating enable, resize set width 40ppt height 100ppt, move position 60ppt 0ppt'';
          criteria = {
            app_id = "info.febvre.Komikku";
          };
        }
        {
          command = ''floating enable, resize set width 50ppt height 50ppt, move position center'';
          criteria = {
            title = "^Virtual Machine Manager$";
            app_id = "virt-manager";
          };
        }
        {
          command = ''floating enable, move position center'';
          criteria = {
            title = "^New VM$";
            app_id = "virt-manager";
          };
        }
        {
          command = ''floating enable, resize set width 80ppt height 80ppt, move position center'';
          criteria = {
            title = "(null)";
            class = "Electron";
          };
        }
        {
          command = ''floating enable, resize set width 80ppt height 80ppt, move position center'';
          criteria = {
            title = ".*";
            app_id = "nemo";
          };
        }
        {
          command = ''floating enable, move position center'';
          criteria = {
            title = "";
            app_id = "nemo";
          };
        }
        {
          command = ''floating enable, resize set width 80ppt height 80ppt, move position center'';
          criteria = {
            title = "Disks";
            app_id = "gnome-disks";
          };
        }
        {
          command = ''floating enable, move position center'';
          criteria = {
            title = ".*";
            app_id = "gnome-disks";
          };
        }
        {
          command = ''floating enable, resize set width 30ppt height 60ppt, move position center'';
          criteria = {
            app_id = "org.gnome.Calculator";
          };
        }
        {
          command = ''floating enable, resize set width 80ppt height 80ppt, move position center'';
          criteria = {
            title = "^Brave$";
          };
        }
        {
          command = ''floating enable, resize set width 15ppt height 15ppt, move position 85ppt 85ppt, sticky on'';
          criteria = {
            title = "^Picture in picture$";
          };
        }
      ];
  };
}
