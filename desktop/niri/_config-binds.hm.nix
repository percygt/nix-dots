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
    in
    {
      # Audio:
      "XF86AudioMicMute".action = spawn "swayosd-client" "--input-volume=mute-toggle";
      "XF86AudioMute".action = spawn "swayosd-client" "--output-volume=mute-toggle";
      "XF86AudioRaiseVolume".action = spawn "swayosd-client" "--output-volume=raise";
      "XF86AudioLowerVolume".action = spawn "swayosd-client" "--output-volume=lower";
      "XF86MonBrightnessUp".action = spawn "swayosd-client" "--brightness=raise";
      "XF86MonBrightnessDown".action = spawn "swayosd-client" "--brightness=lower";
      "XF86AudioPlay".action = playerctl "play-pause";
      "XF86AudioStop".action = playerctl "pause";
      "XF86AudioPrev".action = playerctl "previous";
      "XF86AudioNext".action = playerctl "next";

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
      "Mod+D".action = spawn-sh "pkill tofi || tofi-drun --drun-launch=true --prompt-text=Apps: ";
      "Mod+Y".action = spawn "footpad" "--app-id=yazi" "--" "yazi" "~";
      "Mod+A".action = spawn "footpad" "--app-id=tmux" "--" "tmux-launch-session";
      "Mod+P".action = spawn "footpad" "--app-id=clipboard" "--title=Clipboard" "--" "cliphist-fzf-sixel";
      "Mod+M".action = spawn "footpad" "--title=SystemMonitor" "--app-id=btop" "--" "btop";
      "Mod+B".action = spawn "footpad" "--title=Bluetooth" "--app-id=bluetui" "--" "bluetui";
      "Mod+Alt+L" = {
        action = spawn-sh "niri msg action do-screen-transition && hyprlock --immediate";
        allow-when-locked = true;
      };
      # "Mod+Grave".action = spawn-sh "pkill tofi || ${lib.getExe pkgs.keepmenu}";
      # "Mod+Shift+Grave".action = spawn-sh "pkill tofi || ${lib.getExe pkgs.keepmenu} -C";

      "Mod+O".action = toggle-overview;
      "Mod+Q".action = close-window;
      "Mod+R".action = switch-preset-column-width;
      "Mod+Shift+R".action = switch-preset-window-height;
      "Mod+F".action = maximize-column;

      "Mod+0".action.focus-workspace = 10;
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      "Mod+Shift+0".action.move-column-to-workspace = 10;
      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;

      "Mod+Shift+F".action = fullscreen-window;
      "Mod+Ctrl+F".action = toggle-windowed-fullscreen;
      # "Mod+Shift+F".action = expand-column-to-available-width;
      "Mod+Alt+Space".action = spawn-sh "pkill tofi || ${lib.getExe pkgs.tofi-power-menu}";
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
