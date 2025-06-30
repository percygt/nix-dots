{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;

  toggle-blur = pkgs.writers.writeBash "toggle-blur" ''
    BLUR_STATUS_FILE="/tmp/blur-status"
    if [[ ! -f "$BLUR_STATUS_FILE" ]]; then
        echo "normal" > "$BLUR_STATUS_FILE"
    fi
    enable_blur() {
        swaymsg 'blur enable, blur_radius 7, blur_passes 4, blur_noise 0.05'
        echo "enabled" > "$BLUR_STATUS_FILE"
    }
    normal_blur() {
        swaymsg 'blur_radius 2, blur_passes 4, blur_noise 0'
        echo "normal" > "$BLUR_STATUS_FILE"
    }
    disable_blur() {
        swaymsg 'blur disable'
        echo "disabled" > "$BLUR_STATUS_FILE"
    }
    current_status=$(cat "$BLUR_STATUS_FILE")
    if [[ "$current_status" == "enabled" ]]; then
        normal_blur
    elif [[ "$current_status" == "normal" ]]; then
        disable_blur
    else
        enable_blur
    fi
  '';
in
{
  wayland.windowManager.sway = {
    config.keybindings = lib.mkOptionDefault {
      "${mod}+s" = "exec swaync-client -t -sw";
      "${mod}+Alt+Space" = "exec pkill tofi || ${lib.getExe pkgs.tofi-power-menu}";
      "${mod}+d" =
        "exec pkill tofi-drun || tofi-drun --drun-launch=true --prompt-text=\"Apps: \"| xargs swaymsg exec --";
      "${mod}+x" = "exec pkill tofi-run || tofi-run --prompt-text=\"Run: \"| xargs swaymsg exec --";
      "${mod}+Shift+Tab" = "exec ${lib.getExe pkgs.cycle-sway-output}";
      "${mod}+Tab" = "workspace back_and_forth";
      "${mod}+Backslash" = "exec ${lib.getExe pkgs.cycle-sway-scale}";
      XF86Launch1 = "exec ${lib.getExe pkgs.toggle-service} wlsunset";

      "F11" = "fullscreen toggle";
      "F12" = "exec ${toggle-blur}";

      "${mod}+Ctrl+t" = "layout stacking";
      "${mod}+Shift+t" = "layout tabbed";
      "${mod}+Ctrl+s" = "layout toggle split";
      "${mod}+Shift+r" = "reload";

      "${mod}+Ctrl+l" = "workspace next";
      "${mod}+Ctrl+h" = "workspace prev";

      "${mod}+Print" =
        "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -";
      "Ctrl+Print" =
        "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
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
