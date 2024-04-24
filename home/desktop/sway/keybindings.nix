{
  modifier,
  pkgs,
  libx,
  wezterm,
  up,
  down,
  left,
  right,
  ...
}: let
  inherit (libx) sway;
  inherit (sway) mkWorkspaceKeys mkDirectionKeys;
in {
  keybindings =
    mkDirectionKeys modifier {inherit up down left right;}
    // mkWorkspaceKeys modifier ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"]
    // {
      "${modifier}+f" = "exec ${pkgs.foot}/bin/foot";
      # "${modifier}+Shift+k" = "exec ${pkgs.kitty}/bin/kitty";
      "${modifier}+w" = "exec ${pkgs.i3-quickterm}/bin/i3-quickterm shell";
      "${modifier}+Shift+w" = "exec ${wezterm}/bin/wezterm";
      "${modifier}+Shift+q" = "kill";
      "${modifier}+Shift+c" = "reload";

      "${modifier}+i" = "exec ${pkgs.rofi-wayland}/bin/rofi -show emoji";
      "${modifier}+s" = "exec ${pkgs.rofi-wayland}/bin/rofi -show drun";

      "Ctrl+Alt+l" = "workspace next";
      "Ctrl+Alt+h" = "workspace prev";

      # Split in horizontal orientation:
      "${modifier}+Shift+s" = "split h";

      # Split in vertical orientation:
      "${modifier}+Shift+v" = "split v";

      # Change layout of focused container:
      "${modifier}+o" = "layout stacking";
      "${modifier}+comma" = "layout tabbed";
      "${modifier}+period" = "layout toggle split";

      # Fullscreen for the focused container:
      "${modifier}+u" = "fullscreen toggle";

      # Toggle the current focus between tiling and floating mode:
      "${modifier}+Shift+space" = "floating toggle";

      # Swap focus between the tiling area and the floating area:
      "${modifier}+space" = "focus mode_toggle";

      Print = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -";

      # Backlight:
      XF86MonBrightnessUp = "exec lightctl up";
      XF86MonBrightnessDown = "exec lightctl down";

      # Audio:
      XF86AudioMute = "exec volumectl -u toggle-mute";
      XF86AudioLowerVolume = "exec volumectl -u down";
      XF86AudioRaiseVolume = "exec volumectl -u up";
      XF86AudioMicMute = "exec volumectl -m toggle-mute";

      # Focus the parent container
      "${modifier}+a" = "focus parent";

      # Focus the child container
      "${modifier}+d" = "focus child";

      # Move window to scratchpad:
      "${modifier}+Shift+minus" = "move scratchpad";

      # Show scratchpad window and cycle through them:
      "${modifier}+minus" = "scratchpad show";

      # Enter other modes:
      "${modifier}+r" = "mode resize";
      "${modifier}+Shift+r" = "mode passthrough";
    };
}
