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
  inherit (sway) mkWorkspaceKeys mkDirectionKeys tofipass toggle-blur dropdown-terminal power-menu;
  weztermPackage = config.programs.wezterm.package;
in {
  keybindings =
    mkDirectionKeys mod {inherit up down left right;}
    // mkWorkspaceKeys mod ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"]
    // {
      "Ctrl+KP_Multiply" = "exec ${toggle-blur {inherit pkgs;}}";
      "${mod}+w" = "exec ${dropdown-terminal {inherit pkgs weztermPackage;}}";
      "${mod}+return" = "exec ${terminal}";
      "${mod}+Shift+return" = "exec ${lib.getExe pkgs.i3-quickterm} shell";
      "${mod}+Shift+e" = "exec pkill tofi || ${power-menu {inherit pkgs;}}";
      "${mod}+s" = "exec pkill tofi-drun || tofi-drun --drun-launch=true --prompt-text=\"Apps: \"| xargs swaymsg exec --";
      "${mod}+x" = "exec pkill tofi-run || tofi-run --prompt-text=\"Run: \"| xargs swaymsg exec --";
      "${mod}+m" = "exec ${lib.getExe pkgs.toggle-sway-window} --id btop -- foot --app-id=btop btop";
      "${mod}+v" = "exec ${lib.getExe pkgs.toggle-sway-window} --id pavucontrol -- pavucontrol";
      "${mod}+n" = "exec ${lib.getExe pkgs.toggle-sway-window} --id wpa_gui -- wpa_gui";
      "${mod}+e" = "exec ${lib.getExe pkgs.toggle-sway-window} --id emacs -- emacs ${config.xdg.configHome}/emacs}";
      "${mod}+Shift+i" = "exec ${lib.getExe pkgs.toggle-sway-window} --id \"brave-chatgpt.com__-WebApp-ai\" -- ${config.xdg.desktopEntries.ai.exec}";
      "${mod}+Shift+d" = "exec ${lib.getExe pkgs.toggle-sway-window} --id gnome-disks -- gnome-disks";
      "${mod}+b" = "exec ${lib.getExe pkgs.toggle-sway-window} --id .blueman-manager-wrapped -- blueman-manager";
      "${mod}+k" = "exec pkill tofi || keepmenu -C | xargs swaymsg exec --";
      "${mod}+Shift+k" = "exec pkill tofi || ${tofipass {inherit pkgs;}}";
      "${mod}+f" = "exec ${lib.getExe pkgs.toggle-sway-window} --id yazi -- foot --app-id=yazi fish -c yazi ~";
      "${mod}+shift+tab" = "exec ${lib.getExe pkgs.cycle-sway-output}";
      "${mod}+tab" = "workspace back_and_forth";
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
      "${mod}+Alt+s" = "layout toggle split";
      "${mod}+Shift+s" = "sticky toggle";
      "${mod}+less" = "focus parent";
      "${mod}+greater" = "focus child";
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
