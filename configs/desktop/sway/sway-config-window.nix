{ libx, ... }:
let
  inherit (libx.sway) mkAppsFloat;
in
{
  wayland.windowManager.sway.config.window = {
    titlebar = false;
    border = 1;
    commands =
      (mkAppsFloat {
        titles = [ "^Sign in - Google Accounts.*" ];
        app_ids = [
          "org.gnome.Snapshot"
          "org.gnome.Loupe"
          "org.keepassxc.KeePassXC"
          "btop"
          "backup"
          "system-software-update"
          "page.codeberg.Imaginer.Imaginer"
          "com.github.finefindus.eyedropper"
          "org.gnome.Nautilus"
          "io.github.dvlv.boxbuddyrs"
          "com.github.johnfactotum.Foliate"
          "chrome-chatgpt.com__-WebApp-ai"
          "chrome-app.zoom.us__wc-WebApp-zoom"
          "qalculate-gtk"
        ];
      })
      ++ (mkAppsFloat {
        w = 50;
        h = 50;
        app_ids = [
          "wpa_gui"
          "nm-connection-editor"
          "udiskie"
          "pavucontrol"
          "\.?blueman-manager(-wrapped)?"
        ];
      })
      ++ (mkAppsFloat {
        w = 90;
        h = 90;
        app_ids = [ "clipboard" ];
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
        {
          command = ''border pixel'';
          criteria = {
            app_id = ".*";
          };
        }
        {
          command = ''floating enable, resize set width 100ppt height 100ppt, move position center'';
          criteria = {
            app_id = "foot-ddterm";
          };
        }
        {
          command = ''floating enable, resize set width 80ppt height 80ppt, move position center'';
          criteria = {
            title = "^Friends List$";
            class = "steam";
          };
        }
        {
          command = ''floating enable, resize set width 40ppt height 100ppt, move position 0ppt 0ppt'';
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
          command = ''floating enable, resize set width 20ppt height 20ppt, move position 80ppt 80ppt, sticky on'';
          criteria = {
            title = "^Picture in picture$";
          };
        }
        {
          command = ''floating enable, resize set width 20ppt height 20ppt, move position 80ppt 80ppt, sticky on'';
          criteria = {
            title = "^Picture-in-Picture$";
          };
        }
      ];
  };
}
