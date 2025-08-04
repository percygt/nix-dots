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
      cliphist-clipboard = pkgs.writers.writeBash "cliphist-clipboard" ''
        footclient --app-id=clipboard --title=Clipboard -- cliphist-fzf-sixel
      '';
      tmux-session-term = pkgs.writers.writeBash "tmux-session-term" ''
        footclient --app-id='foot-ddterm' -- tmux-launch-session;
      '';
      yazi-filemanager = pkgs.writers.writeBash "yazi-filemanager" ''
        footclient --app-id=yazi --title='Yazi' -- yazi ~
      '';
      dropdown-term = pkgs.writers.writePython3 "dropdown-term" {
        flakeIgnore = [
          "E501"
          "E265"
        ];
      } (lib.readFile ./.dropdown-term.py);
    in
    {
      # Audio:
      "XF86AudioMute".action = spawn "pamixer" "--toggle-mute";
      "XF86AudioMicMute".action = spawn "pamixer" "--default-source" "-t";

      "XF86AudioPlay".action = playerctl "play-pause";
      "XF86AudioStop".action = playerctl "pause";
      "XF86AudioPrev".action = playerctl "previous";
      "XF86AudioNext".action = playerctl "next";
      "XF86AudioRaiseVolume".action = spawn "pamixer" "--increase" "5";
      "XF86AudioLowerVolume".action = spawn "pamixer" "--decrease" "5";

      # Backlight:
      "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "5%+";
      "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";

      "Print".action.screenshot-screen = {
        write-to-disk = true;
      };
      "Mod+Shift+Alt+S".action = screenshot-window;
      "Mod+Shift+S".action.screenshot = {
        show-pointer = false;
      };

      "Mod+D".action = spawn "tofi-drun" "--drun-launch=true" "--prompt-text=Apps: ";
      "Mod+Return".action = spawn "${dropdown-term}" "footclient" "-a" "ddterm";
      "Mod+Y".action = spawn "${yazi-filemanager}";
      "Mod+T".action = spawn "${tmux-session-term}";
      "Mod+V".action = spawn "${cliphist-clipboard}";
      "Ctrl+Alt+L".action = spawn "hyprlock";

      # "Mod+U".action = spawn "env XDG_CURRENT_DESKTOP=gnome gnome-control-center";

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
