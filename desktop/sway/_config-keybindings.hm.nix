{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;
  foot-ddterm = pkgs.writers.writeBash "foot-ddterm" ''
    footclient --app-id='foot-ddterm' -- tmux-launch-session;
  '';
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
  termMod = config.modules.terminal;
  secMod = config.modules.security;
  viewBackupLogCmd = pkgs.writers.writeBash "viewbackuplogcommand" ''
    footclient --title=BorgmaticBackup --app-id=backup -- journalctl -efo cat -u borgmatic.service
  '';
  cliphistFzfSixel = pkgs.writers.writeBash "cliphistFzfSixel" ''
    footclient --app-id=clipboard --title=Clipboard -- cliphist-fzf-sixel
  '';
  yazi-foot = pkgs.writers.writeBash "yazi-foot" ''
    footclient --app-id=yazi --title='Yazi' -- yazi ~
  '';
in
{
  wayland.windowManager.sway = {
    config.keybindings = lib.mkOptionDefault {
      "${mod}+m" =
        "exec ddapp -t 'btop' -h 90 -w 90 -- 'footclient --title=SystemMonitor --app-id=btop -- btop'";
      "${mod}+f" = "exec ddapp -t 'yazi' -- ${yazi-foot}";
      "${mod}+KP_Multiply" =
        lib.mkIf secMod.keepass.enable "exec pkill tofi || ${lib.getExe pkgs.keepmenu}";
      "${mod}+Alt+KP_Multiply" =
        lib.mkIf secMod.keepass.enable "exec pkill tofi || ${lib.getExe pkgs.keepmenu} -C";
      "Ctrl+KP_Delete" =
        lib.mkIf secMod.borgmatic.enable "exec ddapp -t 'backup' -h 90 -w 90 -- ${viewBackupLogCmd}";
      "Ctrl+Shift+KP_Delete" = lib.mkIf secMod.borgmatic.enable "exec systemctl start borgmatic";
      "${mod}+shift+f" =
        "exec ddapp -t 'org.gnome.Nautilus' -- ${pkgs.writers.writeBash "nautilus-file-manager" ''nautilus ~''}";
      XF86Calculator = "exec ddapp -t 'org.gnome.Calculator' -- gnome-calculator";
      "Ctrl+shift+return" = lib.mkIf termMod.tilix.enable "exec ${lib.getExe termMod.tilix.package}";
      "${mod}+v" =
        "exec ddapp -t 'volume' -h 50 -w 50 -- 'footclient --title=VolumeControl --app-id=volume -- ncpamixer'";
      "${mod}+w" = "exec ddapp -t 'foot-ddterm' -- ${foot-ddterm}";
      "${mod}+s" = "exec swaync-client -t -sw";
      "${mod}+Alt+Space" = "exec pkill tofi || ${lib.getExe pkgs.tofi-power-menu}";
      "${mod}+d" =
        "exec pkill tofi-drun || tofi-drun --drun-launch=true --prompt-text=\"Apps: \"| xargs swaymsg exec --";
      "${mod}+x" = "exec pkill tofi-run || tofi-run --prompt-text=\"Run: \"| xargs swaymsg exec --";
      "${mod}+Shift+Tab" = "exec ${lib.getExe pkgs.cycle-sway-output}";
      "${mod}+Tab" = "workspace back_and_forth";
      "${mod}+Backslash" = "exec ${lib.getExe pkgs.cycle-sway-scale}";

      "${mod}+shift+v" =
        "exec ddapp -t 'clipboard' -n 'Clipboard' -w 90 -h 90 -k true -- ${cliphistFzfSixel}";
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
