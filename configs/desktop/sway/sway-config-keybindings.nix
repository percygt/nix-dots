{
  pkgs,
  lib,
  config,
  libx,
  ...
}:
let

  g = config._base;
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;
  inherit (libx) sway;
  inherit (sway)
    viewRebuildLogCmd
    viewBackupLogCmd
    mkWorkspaceKeys
    mkDirectionKeys
    ;
in
{
  wayland.windowManager.sway = {
    extraConfigEarly = ''
      set {
        $toggle_window ${lib.getExe pkgs.toggle-sway-window}
      }
    '';
    config.keybindings =
      {
        "Ctrl+KP_Insert" = "exec $toggle_window --id system-software-update -- ${viewRebuildLogCmd}";
        "Ctrl+KP_Delete" = "exec $toggle_window --id backup -- ${viewBackupLogCmd}";
        "Ctrl+Shift+KP_Insert" = "exec systemctl --user start nixos-rebuild";
        "${mod}+Space" = "exec swaync-client -t -sw";
        "${mod}+Alt+Space" = "exec pkill tofi || ${lib.getExe pkgs.tofi-power-menu}";
        "${mod}+w" = "exec foot-ddterm";
        "${mod}+Return" = "exec ${lib.getExe g.terminal.default.package}";
        "${mod}+s" = "exec pkill tofi-drun || tofi-drun --drun-launch=true --prompt-text=\"Apps: \"| xargs swaymsg exec --";
        "${mod}+x" = "exec pkill tofi-run || tofi-run --prompt-text=\"Run: \"| xargs swaymsg exec --";
        "${mod}+m" = "exec $toggle_window --id btop -- foot --title=SystemMonitor --app-id=btop btop";
        "${mod}+r" = "exec $toggle_window --id info.febvre.Komikku -- info.febvre.Komikku";
        "${mod}+Shift+v" = "exec $toggle_window --id org.pulseaudio.pavucontrol -- pavucontrol";
        "${mod}+Shift+i" = "exec $toggle_window --id \"chrome-chatgpt.com__-WebApp-ai\" -- ${config.xdg.desktopEntries.ai.exec}";
        "${mod}+Shift+d" = "exec $toggle_window --id gnome-disks -- gnome-disks";
        "${mod}+b" = "exec $toggle_window --id .blueman-manager-wrapped -- blueman-manager";
        "${mod}+p" = "exec pkill tofi || ${lib.getExe pkgs.keepmenu}";
        "${mod}+Alt+p" = "exec pkill tofi || ${lib.getExe pkgs.keepmenu} -C | xargs swaymsg exec --";
        "${mod}+Shift+p" = "exec pkill tofi || ${lib.getExe pkgs.tofi-pass}";
        "${mod}+f" = "exec $toggle_window --id yazi -- foot --app-id=yazi fish -c yazi ~";

        "${mod}+Shift+Tab" = "exec ${lib.getExe pkgs.cycle-sway-output}";
        "${mod}+Tab" = "workspace back_and_forth";
        "${mod}+Backslash" = "exec ${lib.getExe pkgs.cycle-sway-scale}";
        "${mod}+Delete" = "exec swaylock";
        "${mod}+Shift+f" = "exec $toggle_window --id org.gnome.Nautilus -- nautilus ~";
        XF86Calculator = "exec $toggle_window --id org.gnome.Calculator -- gnome-calculator";
        XF86Launch1 = "exec ${lib.getExe pkgs.toggle-service} wlsunset";

        "F11" = "fullscreen toggle";
        "${mod}+Shift+q" = "kill";
        "${mod}+Shift+t" = "layout stacking";
        "${mod}+t" = "layout tabbed";
        "${mod}+Alt+s" = "layout toggle split";
        "${mod}+Shift+s" = "sticky toggle";
        "${mod}+Less" = "focus parent";
        "${mod}+Greater" = "focus child";
        "${mod}+Shift+Minus" = "split h";
        "${mod}+Shift+Backslash" = "split v";
        "${mod}+Shift+Space" = "floating toggle";
        "${mod}+Shift+r" = "reload";

        "Ctrl+Alt+l" = "workspace next";
        "Ctrl+Alt+h" = "workspace prev";

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

        # Move window to scratchpad:
        "${mod}+Minus" = "move scratchpad";

        # Show scratchpad window and cycle through them:
        "${mod}+Plus" = "scratchpad show";

        # Enter other modes:
        # "${mod}+Shift+." = "mode resize";
        # "${mod}+Shift+p" = "mode passthrough";
      }
      // mkDirectionKeys mod {
        inherit (cfg)
          up
          down
          left
          right
          ;
      }
      // mkWorkspaceKeys mod [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "10"
      ];
  };
}
