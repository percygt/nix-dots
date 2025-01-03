{
  pkgs,
  lib,
  config,
  libx,
  ...
}:
let

  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;
  inherit (libx) sway;
  inherit (sway)
    viewRebuildLogCmd
    viewBackupLogCmd
    ;
  foot-ddterm = pkgs.writers.writeBash "foot-ddterm" ''
    foot --app-id=foot-ddterm tmux-launch-session
  '';

  toggle-blur = pkgs.writers.writeBash "toggle-blur" ''
    BLUR_STATUS_FILE="/tmp/blur-status"
    if [[ ! -f "$BLUR_STATUS_FILE" ]]; then
        echo "disabled" > "$BLUR_STATUS_FILE"
    fi
    enable_blur() {
        swaymsg 'blur enable, blur_radius 7, blur_passes 4, blur_noise 0.05'
        echo "enabled" > "$BLUR_STATUS_FILE"
    }
    lighten_blur() {
        swaymsg 'blur_radius 2, blur_passes 4, blur_noise 0'
        echo "lightened" > "$BLUR_STATUS_FILE"
    }
    disable_blur() {
        swaymsg 'blur disable'
        echo "disabled" > "$BLUR_STATUS_FILE"
    }
    current_status=$(cat "$BLUR_STATUS_FILE")
    if [[ "$current_status" == "enabled" ]]; then
        lighten_blur
    elif [[ "$current_status" == "lightened" ]]; then
        disable_blur
    else
        enable_blur
    fi
  '';
in
{
  wayland.windowManager.sway = {
    extraConfigEarly = ''
      set {
        $toggle_window ${lib.getExe pkgs.toggle-sway-window}
      }
    '';
    config.keybindings = lib.mkOptionDefault {
      "Ctrl+KP_Insert" = "exec $toggle_window --id system-software-update -- ${viewRebuildLogCmd}";
      "Ctrl+KP_Delete" = "exec $toggle_window --id backup -- ${viewBackupLogCmd}";
      "Ctrl+Shift+KP_Insert" = "exec systemctl --user start nixos-rebuild";
      "${mod}+s" = "exec swaync-client -t -sw";
      "${mod}+Alt+Space" = "exec pkill tofi || ${lib.getExe pkgs.tofi-power-menu}";
      "${mod}+w" = "exec ddapp -t 'foot-ddterm' -c ${foot-ddterm}";
      "${mod}+d" = "exec pkill tofi-drun || tofi-drun --drun-launch=true --prompt-text=\"Apps: \"| xargs swaymsg exec --";
      "${mod}+x" = "exec pkill tofi-run || tofi-run --prompt-text=\"Run: \"| xargs swaymsg exec --";
      "${mod}+m" = "exec $toggle_window --id btop -- foot --title=SystemMonitor --app-id=btop btop";
      "${mod}+r" = "exec $toggle_window --id info.febvre.Komikku -- info.febvre.Komikku";
      "${mod}+Shift+i" = "exec $toggle_window --id \"chrome-chatgpt.com__-WebApp-ai\" -- ${config.xdg.desktopEntries.ai.exec}";
      "${mod}+Shift+d" = "exec $toggle_window --id gnome-disks -- gnome-disks";
      "${mod}+b" = "exec $toggle_window --id .blueman-manager-wrapped -- blueman-manager";
      "${mod}+p" = "exec pkill tofi || ${lib.getExe pkgs.keepmenu}";
      "${mod}+Alt+p" = "exec pkill tofi || ${lib.getExe pkgs.keepmenu} -C | xargs swaymsg exec --";
      "${mod}+Shift+p" = "exec pkill tofi || ${lib.getExe pkgs.tofi-pass}";

      "${mod}+Shift+Tab" = "exec ${lib.getExe pkgs.cycle-sway-output}";
      "${mod}+Tab" = "workspace back_and_forth";
      "${mod}+Backslash" = "exec ${lib.getExe pkgs.cycle-sway-scale}";
      "${mod}+Delete" = "exec swaylock";
      XF86Calculator = "exec $toggle_window --id org.gnome.Calculator -- gnome-calculator";
      XF86Launch1 = "exec ${lib.getExe pkgs.toggle-service} wlsunset";

      "F12" = "exec $toggle_window --id org.pulseaudio.pavucontrol -- pavucontrol";
      "F11" = "fullscreen toggle";
      "F10" = "exec ${toggle-blur}";
      "${mod}+Shift+t" = "layout stacking";
      "${mod}+t" = "layout tabbed";
      "${mod}+Alt+s" = "layout toggle split";
      "${mod}+Shift+s" = "splith";
      "${mod}+Shift+v" = "splitv";
      "${mod}+Shift+r" = "reload";

      "${mod}+Shift+l" = "workspace next";
      "${mod}+Shift+h" = "workspace prev";

      "${mod}+Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -";
      "Ctrl+Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
      "Alt+Print" = "exec ocr";

      # Backlight:
      XF86MonBrightnessUp = "exec brightnessctl set 5%+";
      XF86MonBrightnessDown = "exec brightnessctl set 5%-";

      # Audio:
      XF86AudioMute = "exec pamixer --toggle-mute";
      XF86AudioLowerVolume = "exec pamixer --decrease 5";
      XF86AudioRaiseVolume = "exec pamixer --increase 5";
      XF86AudioMicMute = "exec pamixer --default-source -t";
    };
  };
}
