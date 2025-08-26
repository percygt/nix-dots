{
  programs.niri.settings = {
    window-rules = [
      {
        geometry-corner-radius =
          let
            radius = 10.0;
          in
          {
            bottom-left = radius;
            bottom-right = radius;
            top-left = radius;
            top-right = radius;
          };
        clip-to-geometry = true;
        draw-border-with-background = false;
      }
      {
        matches = [
          { app-id = "tmux"; }
        ];
        geometry-corner-radius =
          let
            radius = 0.0;
          in
          {
            bottom-left = radius;
            bottom-right = radius;
            top-left = radius;
            top-right = radius;
          };
        border.enable = false;
      }
      {
        matches = [
          { is-focused = false; }
        ];
        opacity = 0.98;
        shadow.enable = false;
      }
      {
        matches = [
          { is-floating = true; }
        ];
        shadow.enable = true;
      }
      {
        matches = [
          {
            is-window-cast-target = true;
          }
        ];
        focus-ring = {
          active.color = "#f38ba8";
          inactive.color = "#7d0d2d";
        };
        border = {
          inactive.color = "#7d0d2d";
        };
        shadow = {
          color = "#7d0d2d70";
        };
        tab-indicator = {
          active.color = "#f38ba8";
          inactive.color = "#7d0d2d";
        };
      }
      {
        matches = [
          { app-id = "org.keepassxc.KeePassXC"; }
          { app-id = "app.drey.PaperPlane"; }
          { app-id = "org.telegram.desktop"; }
        ];
        block-out-from = "screencast";
      }
      {
        matches = [
          { app-id = "tmux"; }
        ];
        open-floating = true;
        default-column-width = {
          proportion = 1.00;
        };
        default-window-height = {
          proportion = 1.00;
        };
      }
      {
        matches = [
          { app-id = ".scrcpy-wrapped"; }
          { app-id = "pavucontrol"; }
          { app-id = "pavucontrol-qt"; }
          { app-id = "com.saivert.pwvucontrol"; }
          { app-id = "dialog"; }
          { app-id = "popup"; }
          { app-id = "task_dialog"; }
          { app-id = "gcr-prompter"; }
          { app-id = "file-roller"; }
          { app-id = "org.gnome.FileRoller"; }
          { app-id = "nm-connection-editor"; }
          { app-id = "blueman-manager"; }
          { app-id = "xdg-desktop-portal-gtk"; }
          { app-id = "org.kde.polkit-kde-authentication-agent-1"; }
          { app-id = "pinentry"; }
          { title = "Progress"; }
          { title = "File Operations"; }
          { title = "Copying"; }
          { title = "Moving"; }
          { title = "Properties"; }
          { title = "Downloads"; }
          { title = "file progress"; }
          { title = "Confirm"; }
          { title = "Authentication Required"; }
          { title = "Notice"; }
          { title = "Warning"; }
          { title = "Error"; }
        ];
        open-floating = true;
      }
      {
        matches = [
          { app-id = "org.keepassxc.KeePassXC"; }
          { app-id = "gnome-disks"; }
          { app-id = "lollypop"; }
          { app-id = "io.github.dvlv.boxbuddyrs"; }
          { app-id = "org.gnome.Firmware"; }
          { app-id = "\.?qemu-system-x86_64(-wrapped)?"; }
          { app-id = "Spotify"; }
          { title = "^Brave$"; }
          { app-id = "yazi"; }
          { app-id = "clipboard"; }
          { app-id = "btop"; }
          {
            title = "^Friends List$";
            app-id = "steam";
          }
        ];
        open-floating = true;
        default-column-width = {
          proportion = 0.80;
        };
        default-window-height = {
          proportion = 0.80;
        };
      }
      {
        matches = [
          { app-id = "wpa_gui"; }
          {
            app-id = "org.gnome.Nautilus";
            title = "^Properties$";
          }
          { app-id = "nm-connection-editor"; }
          { app-id = "udiskie"; }
        ];
        open-floating = true;
        default-column-width = {
          proportion = 0.50;
        };
        default-window-height = {
          proportion = 0.50;
        };
      }
      {
        matches = [
          { app-id = "zen"; }
          { app-id = "firefox"; }
          { app-id = "brave-browser"; }
          { app-id = "chromium-browser"; }
        ];
        open-maximized = true;
      }
      {
        matches = [
          { title = "^Picture-in-Picture$"; }
          { title = "^Picture in picture$"; }
        ];
        open-floating = true;
        default-floating-position = {
          x = 32;
          y = 32;
          relative-to = "bottom-right";
        };
        default-column-width = {
          fixed = 480;
        };
        default-window-height = {
          fixed = 270;
        };
      }
      {
        matches = [ { title = "Discord Popout"; } ];
        open-floating = true;
        default-floating-position = {
          x = 32;
          y = 32;
          relative-to = "bottom-right";
        };
      }
    ];
    layer-rules = [
      {
        matches = [ { namespace = "^swww$"; } ];
        place-within-backdrop = true;
      }
    ];
  };
}
