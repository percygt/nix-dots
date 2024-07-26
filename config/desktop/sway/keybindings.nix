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
}:
let
  mod = modifier;
  inherit (libx) sway;
  inherit (sway)
    viewRebuildLogCmd
    mkWorkspaceKeys
    mkDirectionKeys
    tofipass
    toggle-blur
    dropdown-terminal
    power-menu
    ;
  weztermPackage = config.programs.wezterm.package;
in
{
  keybindings =
    mkDirectionKeys mod {
      inherit
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
    ]
    // {
      "Ctrl+KP_Multiply" = "exec ${toggle-blur { inherit pkgs; }}";
      "Ctrl+KP_Insert" = "exec ${lib.getExe pkgs.toggle-sway-window} --id nixos_rebuild_log -- ${viewRebuildLogCmd}";
      "Ctrl+Shift+KP_Insert" = "exec systemctl --user start nixos-rebuild";
      "${mod}+w" = "exec ${dropdown-terminal { inherit pkgs weztermPackage; }}";
      "${mod}+Return" = "exec ${terminal}";
      "${mod}+Shift+return" = "exec ${lib.getExe pkgs.i3-quickterm} shell";
      "${mod}+Shift+e" = "exec pkill tofi || ${power-menu { inherit pkgs; }}";
      "${mod}+s" = "exec pkill tofi-drun || tofi-drun --drun-launch=true --prompt-text=\"Apps: \"| xargs swaymsg exec --";
      "${mod}+x" = "exec pkill tofi-run || tofi-run --prompt-text=\"Run: \"| xargs swaymsg exec --";
      "${mod}+m" = "exec ${lib.getExe pkgs.toggle-sway-window} --id btop -- foot --app-id=btop btop";
      "${mod}+v" = "exec ${lib.getExe pkgs.toggle-sway-window} --id pavucontrol -- pavucontrol";
      "${mod}+n" = "exec ${lib.getExe pkgs.toggle-sway-window} --id wpa_gui -- wpa_gui";
      "${mod}+e" = "exec ${lib.getExe pkgs.toggle-sway-window} --id emacs --width 100 --height 100 -- emacs";
      "${mod}+Shift+i" = "exec ${lib.getExe pkgs.toggle-sway-window} --id \"brave-chatgpt.com__-WebApp-ai\" -- ${config.xdg.desktopEntries.ai.exec}";
      "${mod}+Shift+d" = "exec ${lib.getExe pkgs.toggle-sway-window} --id gnome-disks -- gnome-disks";
      "${mod}+b" = "exec ${lib.getExe pkgs.toggle-sway-window} --id .blueman-manager-wrapped -- blueman-manager";
      "${mod}+k" = "exec pkill tofi || keepmenu -C | xargs swaymsg exec --";
      "${mod}+Shift+k" = "exec pkill tofi || ${tofipass { inherit pkgs; }}";
      "${mod}+f" = "exec ${lib.getExe pkgs.toggle-sway-window} --id yazi -- foot --app-id=yazi fish -c yazi ~";
      "${mod}+Shift+Tab" = "exec ${lib.getExe pkgs.cycle-sway-output}";
      "${mod}+Tab" = "workspace back_and_forth";
      "${mod}+Backslash" = "exec ${lib.getExe pkgs.cycle-sway-scale}";
      "${mod}+Delete" = "exec swaylock";
      #FIXME:
      "${mod}+Shift+v" = "exec ${lib.getExe pkgs.cycle-pulse-sink}";

      XF86Calculator = "exec ${lib.getExe pkgs.toggle-sway-window} --id qalculate-gtk -- qalculate-gtk";
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
      "${mod}+Space" = "focus mode_toggle";
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
      "${mod}+Shift+Plus" = "move scratchpad";

      # Show scratchpad window and cycle through them:
      "${mod}+Plus" = "scratchpad show";

      # Enter other modes:
      "${mod}+r" = "mode resize";
      "${mod}+Shift+p" = "mode passthrough";
    };
}
