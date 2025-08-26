{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.niri.settings.binds =
    with config.lib.niri.actions;
    let
      playerctl = spawn "${lib.getExe pkgs.playerctl}";
      secMod = config.modules.security;
      cycle-brightness = pkgs.writers.writeBash "cycle-brightness" ''
        state_file="$XDG_CACHE_HOME/brightness_cycle_state"
        values=(80 55 30 15 0 100)
        if [[ -f "$state_file" ]]; then
          current_index=$(cat "$state_file")
        else
          current_index=-1
        fi
        next_index=$(( (current_index + 1) % ''${#values[@]} ))
        brightness=''${values[$next_index]}
        echo "$next_index" > "$state_file"
        backlightset "$brightness"
      '';
      sh = spawn "sh" "-c";
    in
    {
      # Audio:
      # "XF86AudioMute".action = spawn "pamixer" "--toggle-mute";
      # "XF86AudioMicMute".action = spawn "pamixer" "--default-source" "-t";
      "XF86AudioMicMute".action = sh "swayosd-client --input-volume=mute-toggle";
      "XF86AudioMute".action = sh "swayosd-client --output-volume=mute-toggle";
      "XF86AudioRaiseVolume".action = sh "swayosd-client --output-volume=raise";
      "XF86AudioLowerVolume".action = sh "swayosd-client --output-volume=lower";
      "XF86MonBrightnessUp".action = sh "swayosd-client --brightness=raise";
      "XF86MonBrightnessDown".action = sh "swayosd-client --brightness=lower";
      "XF86AudioPlay".action = playerctl "play-pause";
      "XF86AudioStop".action = playerctl "pause";
      "XF86AudioPrev".action = playerctl "previous";
      "XF86AudioNext".action = playerctl "next";

      # "XF86AudioRaiseVolume".action = spawn "pamixer" "--increase" "5";
      # "XF86AudioLowerVolume".action = spawn "pamixer" "--decrease" "5";

      # Backlight:
      # "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "5%+";
      # "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";

      "Mod+Shift+B".action = spawn "${cycle-brightness}";

      "Mod+Insert".action = set-dynamic-cast-window;
      "Mod+Shift+Insert".action = set-dynamic-cast-monitor;
      "Mod+Delete".action = clear-dynamic-cast-target;

      "Alt+Print".action = spawn "ocr";
      "Ctrl+Print".action.screenshot-screen = {
        write-to-disk = false;
      };
      "Mod+Ctrl+Print".action.screenshot-window = {
        write-to-disk = false;
      };
      "Print".action.screenshot-screen = {
        write-to-disk = true;
      };
      "Mod+Print".action = screenshot-window;
      "Mod+Shift+Print".action.screenshot = {
        show-pointer = false;
      };

      "Mod+S".action = spawn "swaync-client" "-t" "-sw";
      "Mod+D".action = spawn "sh" "-c" "pkill tofi || tofi-drun --drun-launch=true --prompt-text=Apps: ";
      "Mod+Y".action = spawn "footpad" "--app-id=yazi" "--" "yazi" "~";
      "Mod+A".action = spawn "footpad" "--app-id=tmux" "--" "tmux-launch-session";
      "Mod+V".action = spawn "footpad" "--app-id=clipboard" "--title=Clipboard" "--" "cliphist-fzf-sixel";
      "Mod+M".action = spawn "footpad" "--title=SystemMonitor" "--app-id=btop" "--" "btop";
      "Ctrl+Alt+L".action = spawn "hyprlock";
      "Mod+KP_Multiply" = lib.mkIf secMod.keepass.enable {
        action = spawn "sh" "-c" "pkill tofi || ${lib.getExe pkgs.keepmenu}";
      };
      "Mod+Alt+KP_Multiply" = lib.mkIf secMod.keepass.enable {
        action = spawn "sh" "-c" "pkill tofi || ${lib.getExe pkgs.keepmenu} -C";
      };

      "Mod+O".action = toggle-overview;
      "Mod+Q".action = close-window;
      "Mod+R".action = switch-preset-column-width;
      "Mod+Shift+R".action = switch-preset-window-height;
      "Mod+F".action = maximize-column;

      "Mod+1".action = set-column-width "25%";
      "Mod+2".action = set-column-width "50%";
      "Mod+3".action = set-column-width "75%";
      "Mod+4".action = set-column-width "100%";
      "Mod+Shift+F".action = fullscreen-window;
      # "Mod+Shift+F".action = expand-column-to-available-width;
      "Mod+Alt+Space".action = spawn "sh" "-c" "pkill tofi || ${lib.getExe pkgs.tofi-power-menu}";
      "Mod+Space".action = toggle-window-floating;
      "Mod+Shift+Space".action = switch-focus-between-floating-and-tiling;

      "Mod+W".action = toggle-column-tabbed-display;

      "Mod+Comma".action = consume-window-into-column;
      "Mod+Period".action = expel-window-from-column;
      "Mod+C".action = center-visible-columns;

      "Mod+Tab".action = focus-workspace-previous;
      "Mod+Shift+Tab".action = focus-monitor-previous;
      "Alt+Tab".action = focus-window-previous;

      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Equal".action = set-column-width "+10%";
      "Mod+Shift+Minus".action = set-window-height "-10%";
      "Mod+Shift+Equal".action = set-window-height "+10%";

      "Mod+H".action = focus-column-or-monitor-left;
      "Mod+L".action = focus-column-or-monitor-right;
      "Mod+J".action = focus-window-or-workspace-down;
      "Mod+K".action = focus-window-or-workspace-up;
      "Mod+Left".action = focus-column-left;
      "Mod+Right".action = focus-column-right;
      "Mod+Down".action = focus-workspace-down;
      "Mod+Up".action = focus-workspace-up;

      "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
      "Mod+Shift+L".action = move-column-right-or-to-monitor-right;
      "Mod+Shift+K".action = move-column-to-workspace-up;
      "Mod+Shift+J".action = move-column-to-workspace-down;

      "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

      "Mod+Shift+P".action = power-off-monitors;

    };
}
