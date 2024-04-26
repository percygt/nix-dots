{
  modifier,
  pkgs,
  libx,
  up,
  down,
  left,
  right,
  lib,
  terminal,
  config,
  ...
}: let
  mod = modifier;
  inherit (libx) sway;
  inherit (sway) mkWorkspaceKeys mkDirectionKeys;
  toggle-sway-window = pkgs.writeBabashkaScript {
    name = "toggle-sway-window";
    text = builtins.readFile ./toggle-sway-window.clj;
  };
  cycle-sway-output = pkgs.writeBabashkaScript {
    name = "cycle-sway-output";
    text = builtins.readFile ./cycle-sway-output.clj;
  };
  cycle-sway-scale = pkgs.writeBabashkaScript {
    name = "cycle-sway-scale";
    text = builtins.readFile ./cycle-sway-scale.clj;
  };
  cycle-pulse-sink = pkgs.writeBabashkaScript {
    name = "cycle-pulse-sink";
    text = builtins.readFile ./cycle-pulse-sink.clj;
    runtimeInputs = [pkgs.pulseaudioFull];
  };
  toggle-notifications = pkgs.writers.writeBash "toggle-notifications" ''
    if makoctl mode | grep -q "default"; then
      makoctl mode -s hidden
    else
      makoctl mode -s default
    fi
  '';
  dropdown-terminal = pkgs.writers.writeBash "dropdown_terminal" ''
    TERM_PIDFILE="/tmp/wezterm-dropdown"
    TERM_PID="$(<"$TERM_PIDFILE")"
    if swaymsg "[ pid=$TERM_PID ] scratchpad show"
    then
        swaymsg "[ pid=$TERM_PID ] resize set 100ppt 100ppt , move position 0 0"
    else
        echo "$$" > "$TERM_PIDFILE"
        swaymsg "for_window [ pid=$$ ] 'floating enable ; resize set 100ppt 100ppt ; move position 0 0 ; move to scratchpad ; scratchpad show'"
        exec "${config.programs.wezterm.package}/bin/wezterm";
    fi
  '';
  power-menu = pkgs.writers.writeBash "power-menu" ''
    pkill tofi || case $(printf "%s\n" "Power Off" "Restart" "Suspend" "Lock" "Log Out" | ${pkgs.tofi}/bin/tofi) in
    "Power Off")
      systemctl poweroff
      ;;
    "Restart")
      systemctl reboot
      ;;
    "Suspend")
      systemctl suspend
      ;;
    "Lock")
      swaylock
      ;;
    "Log Out")
      swaymsg exit
      ;;
    esac
  '';
in {
  keybindings =
    mkDirectionKeys mod {inherit up down left right;}
    // mkWorkspaceKeys mod ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"]
    // {
      "${mod}+w" = "exec ${dropdown-terminal}";
      "${mod}+return" = "exec ${terminal}";
      "${mod}+Shift+return" = "exec ${lib.getExe pkgs.i3-quickterm} shell";
      "${mod}+s" = "exec pkill tofi-drun || ${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
      "${mod}+x" = "exec pkill tofi-run || ${pkgs.tofi}/bin/tofi-run | xargs swaymsg exec --";
      "${mod}+m" = "exec ${lib.getExe toggle-sway-window} --id btop -- ${terminal} --app-id=btop ${lib.getExe pkgs.btop}";
      "${mod}+v" = "exec ${lib.getExe toggle-sway-window} --id pavucontrol -- pavucontrol";
      "${mod}+Shift+d" = "exec ${lib.getExe toggle-sway-window} --id gnome-disks -- gnome-disks";
      "${mod}+b" = "exec ${lib.getExe toggle-sway-window} --id .blueman-manager-wrapped --width 80 --height 80 -- blueman-manager";
      "${mod}+Shift+k" = "exec ${lib.getExe toggle-sway-window} --id org.keepassxc.KeePassXC -- keepassxc";
      "${mod}+f" = "exec ${lib.getExe toggle-sway-window} --id yazi -- foot --app-id=yazi fish -c yazi ~";
      "${mod}+shift+tab" = "exec ${lib.getExe cycle-sway-output}";
      "${mod}+backslash" = "exec ${lib.getExe cycle-sway-scale}";
      "${mod}+shift+v" = "exec ${lib.getExe cycle-pulse-sink}";
      "${mod}+shift+n" = "exec ${toggle-notifications}";
      "${mod}+delete" = "exec swaylock";
      XF86Calculator = "exec ${lib.getExe toggle-sway-window} --id qalculate-gtk -- qalculate-gtk";
      XF86Launch1 = "exec ${lib.getExe pkgs.toggle-service} wlsunset";

      "F11" = "fullscreen toggle";
      "${mod}+Shift+q" = "kill";
      "${mod}+n" = "layout stacking";
      "${mod}+t" = "layout tabbed";
      "${mod}+e" = "layout toggle split";
      "${mod}+Shift+s" = "sticky toggle";
      "${mod}+less" = "focus parent";
      "${mod}+greater" = "focus child";
      "${mod}+tab" = "workspace back_and_forth";
      "${mod}+Shift+minus" = "split h";
      "${mod}+Shift+backslash" = "split v";
      "${mod}+Shift+space" = "floating toggle";
      "${mod}+space" = "focus mode_toggle";
      "${mod}+Shift+r" = "reload";

      "Ctrl+Alt+l" = "workspace next";
      "Ctrl+Alt+h" = "workspace prev";

      Print = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -";

      # Backlight:
      XF86MonBrightnessUp = "exec brightnessctl set 5%+";
      XF86MonBrightnessDown = "exec brightnessctl set 5%-";

      # Audio:
      XF86AudioMute = "exec pamixer --toggle-mute";
      XF86AudioLowerVolume = "exec pamixer --decrease 5";
      XF86AudioRaiseVolume = "exec pamixer --increase 5";
      XF86AudioMicMute = "exec pamixer --default-source -t";

      # Move window to scratchpad:
      "${mod}+Shift+plus" = "move scratchpad";

      # Show scratchpad window and cycle through them:
      "${mod}+plus" = "scratchpad show";

      # Enter other modes:
      "${mod}+r" = "mode resize";
      "${mod}+Shift+p" = "mode passthrough";

      "${mod}+Shift+e" = "exec ${power-menu}";
    };
}
