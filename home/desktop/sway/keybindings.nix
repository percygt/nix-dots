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
  # passmenu = pkgs.writers.writeBash "passmenu" ''
  #   # shopt -s nullglob globstar
  #
  #   dmenu=${pkgs.tofi}/bin/tofi  --prompt-text="Power Menu: "
  #
  #   prefix=''${PASSWORD_STORE_DIR- ~/.password-store}
  #   password_files=( "$prefix"/**/*.gpg )
  #   password_files=( "''${password_files[@]#"$prefix"/}" )
  #   password_files=( "''${password_files[@]%.gpg}" )
  #   password=''$(printf '%s\n' "''${password_files[@]}" | "$dmenu" "$@")
  #
  #   [[ -n $password ]] || exit
  #
  #   pass show -c "$password" 2>/dev/null
  # '';
  dropdown-terminal = pkgs.writers.writeBash "dropdown_terminal" ''
    TERM_PIDFILE="/tmp/wezterm-dropdown"
    TERM_PID="$(<"$TERM_PIDFILE")"
    if swaymsg "[ pid=$TERM_PID ] scratchpad show"
    then
        swaymsg "[ pid=$TERM_PID ] resize set 100ppt 100ppt , move position center"
    else
        echo "$$" > "$TERM_PIDFILE"
        swaymsg "for_window [ pid=$$ ] 'floating enable ; resize set 100ppt 100ppt ; move position center ; move to scratchpad ; scratchpad show'"
        exec "${config.programs.wezterm.package}/bin/wezterm";
    fi
  '';
  toggle-blur = pkgs.writers.writeBash "toggle-blur" ''
    BLUR_STATUS_FILE="/tmp/blur-status"
    BLUR_STATUS=$(<"$BLUR_STATUS_FILE")
    if [ ! -f "$BLUR_STATUS_FILE" ]; then
        echo "0" > "$BLUR_STATUS_FILE"
    else
        swaymsg "blur $BLUR_STATUS"
        echo $((1 - BLUR_STATUS)) > "$BLUR_STATUS_FILE"
    fi
  '';
  power-menu = pkgs.writers.writeBash "power-menu" ''
    pkill tofi || case $(printf "%s\n" "Power Off" "Restart" "Suspend" "Lock" "Log Out" | ${pkgs.tofi}/bin/tofi  --prompt-text="Power Menu: ") in
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
      "Ctrl+KP_Multiply" = "exec ${toggle-blur}";
      "${mod}+w" = "exec ${dropdown-terminal}";
      "${mod}+return" = "exec ${terminal}";
      "${mod}+Shift+return" = "exec ${lib.getExe pkgs.i3-quickterm} shell";
      "${mod}+Shift+e" = "exec ${power-menu}";
      "${mod}+s" = "exec pkill tofi-drun || ${pkgs.tofi}/bin/tofi-drun --drun-launch=true --prompt-text=\"Apps: \"| xargs swaymsg exec --";
      "${mod}+x" = "exec pkill tofi-run || ${pkgs.tofi}/bin/tofi-run --prompt-text=\"Run: \"| xargs swaymsg exec --";
      "${mod}+m" = "exec ${lib.getExe pkgs.toggle-sway-window} --id btop -- foot --app-id=btop btop";
      "${mod}+v" = "exec ${lib.getExe pkgs.toggle-sway-window} --id pavucontrol -- pavucontrol";
      "${mod}+n" = "exec ${lib.getExe pkgs.toggle-sway-window} --id wpa_gui -- wpa_gui";
      "${mod}+Shift+i" = "exec ${lib.getExe pkgs.toggle-sway-window} --id \"brave-chatgpt.com__-WebApp-ai\" -- ${config.xdg.desktopEntries.ai.exec}";
      "${mod}+Shift+d" = "exec ${lib.getExe pkgs.toggle-sway-window} --id gnome-disks -- gnome-disks";
      "${mod}+b" = "exec ${lib.getExe pkgs.toggle-sway-window} --id .blueman-manager-wrapped -- blueman-manager";
      "${mod}+Shift+k" = "exec keepmenu -C";
      # "${mod}+k" = "exec ${passmenu}";
      "${mod}+f" = "exec ${lib.getExe pkgs.toggle-sway-window} --id yazi -- foot --app-id=yazi fish -c yazi ~";
      "${mod}+shift+tab" = "exec ${lib.getExe pkgs.cycle-sway-output}";
      "${mod}+backslash" = "exec ${lib.getExe pkgs.cycle-sway-scale}";
      "${mod}+delete" = "exec swaylock";
      #FIXME:
      "${mod}+shift+v" = "exec ${lib.getExe pkgs.cycle-pulse-sink}";

      XF86Calculator = "exec ${lib.getExe pkgs.toggle-sway-window} --id qalculate-gtk -- qalculate-gtk";
      XF86Launch1 = "exec ${lib.getExe pkgs.toggle-service} wlsunset";

      "F11" = "fullscreen toggle";
      "${mod}+Shift+q" = "kill";
      "${mod}+Shift+t" = "layout stacking";
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
    };
}
