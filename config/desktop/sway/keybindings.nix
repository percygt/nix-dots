{
  pkgs,
  lib,
  config,
  libx,
  isGeneric,
  ...
}:
let
  g = config._general;
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;
  wez-ddterm = if isGeneric then pkgs.wez-wrapped-ddterm else pkgs.wez-nightly-ddterm;
  inherit (libx) sway;
  inherit (sway)
    viewRebuildLogCmd
    viewBackupLogCmd
    mkWorkspaceKeys
    mkDirectionKeys
    ;
  emacsconfig = pkgs.writeScriptBin "emacsconfig" ''
    emacsclient -F '((name . "EmacsConfig"))' -c ${g.flakeDirectory}/modules/editor/emacs;
  '';
in
{
  home.packages = [
    emacsconfig
    (pkgs.writers.writeBashBin "ddapp" { }
      #bash
      ''
        while getopts p:c: flag
        do
            case "''${flag}" in
                p) params=''${OPTARG};;
                c) command=''${OPTARG};;
            esac
        done
        if swaymsg "$params scratchpad show"
        then
            swaymsg "$params resize set 100ppt 100ppt , move position center"
        else
            swaymsg "for_window $params 'floating enable ; resize set 100ppt 100ppt ; move position center ; move to scratchpad ; scratchpad show'"
            exec $command
        fi
      ''
    )
    (pkgs.writers.writeBashBin "emacsnote" { } ''
      emacsclient -c -e '(org-roam-node-find)' -F '((name . "Notes"))' 
    '')
  ];
  wayland.windowManager.sway = {
    extraConfigEarly = ''
      set {
        $maximize move position center, resize set width 100 ppt height 100 ppt
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
        "Ctrl+Alt+w" = "exec ${lib.getExe wez-ddterm}";
        "${mod}+w" = "exec ${lib.getExe pkgs.foot-ddterm}";
        "Ctrl+Alt+return" = "exec ${lib.getExe config.programs.wezterm.package}";
        "${mod}+Return" = "exec ${lib.getExe pkgs.foot}";
        "${mod}+s" = "exec pkill tofi-drun || tofi-drun --drun-launch=true --prompt-text=\"Apps: \"| xargs swaymsg exec --";
        "${mod}+x" = "exec pkill tofi-run || tofi-run --prompt-text=\"Run: \"| xargs swaymsg exec --";
        "${mod}+m" = "exec $toggle_window --id btop -- foot --title=SystemMonitor --app-id=btop btop";
        "${mod}+v" = "exec $toggle_window --id pavucontrol -- pavucontrol";
        "${mod}+r" = "exec $toggle_window --id info.febvre.Komikku -- info.febvre.Komikku";
        "${mod}+n" = "exec $toggle_window --id wpa_gui -- wpa_gui";
        "${mod}+e" = "exec swaymsg [ app_id=emacs title=^Notes$ ] scratchpad show || exec emacsnote, $maximize";
        "${mod}+Shift+e" = "exec ddapp -p \"[ app_id=emacs title=^EmacsConfig$ ]\" -c ${emacsconfig}/bin/emacsconfig";
        "${mod}+Shift+i" = "exec $toggle_window --id \"chrome-chatgpt.com__-WebApp-ai\" -- ${config.xdg.desktopEntries.ai.exec}";
        "${mod}+Shift+d" = "exec $toggle_window --id gnome-disks -- gnome-disks";
        "${mod}+b" = "exec $toggle_window --id .blueman-manager-wrapped -- blueman-manager";
        "${mod}+k" = "exec pkill tofi || ${lib.getExe pkgs.keepmenu} | xargs swaymsg exec --";
        "${mod}+Shift+k" = "exec pkill tofi || ${lib.getExe pkgs.tofi-pass} | xargs swaymsg exec --";
        "${mod}+f" = "exec $toggle_window --id yazi -- foot --app-id=yazi fish -c yazi ~";
        "${mod}+Shift+f" = "exec $toggle_window --id nemo -- nemo ~";
        "${mod}+Shift+Tab" = "exec ${lib.getExe pkgs.cycle-sway-output}";
        "${mod}+Tab" = "workspace back_and_forth";
        "${mod}+Backslash" = "exec ${lib.getExe pkgs.cycle-sway-scale}";
        "${mod}+Delete" = "exec swaylock";

        XF86Calculator = "exec $toggle_window --id qalculate-gtk -- qalculate-gtk";
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

        "Ctrl+Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -";

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
        # "${mod}+r" = "mode resize";
        "${mod}+Shift+p" = "mode passthrough";
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
