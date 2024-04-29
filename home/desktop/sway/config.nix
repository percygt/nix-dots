{
  pkgs,
  config,
  lib,
  libx,
  ...
}: let
  inherit (libx) colors fonts sway wallpaper;
  fnts = fonts;
  inherit (sway) mkAppsFloatCenter;
  clrs = colors;
in {
  config = rec {
    fonts = {
      names = [fnts.app.name];
      style = fnts.app.style;
      size = fnts.app.size;
    };
    modifier = "Mod4";
    up = "k";
    down = "j";
    left = "h";
    right = "l";
    terminal = "${pkgs.foot}/bin/foot";
    output."*".bg = "${wallpaper} fill";
    inherit (import ./keybindings.nix {inherit modifier pkgs libx lib config up down left right terminal;}) keybindings;
    inherit (import ./startup.nix) startup;
    inherit (import ./window.nix {inherit mkAppsFloatCenter;}) window;
    input = {
      "type:touchpad" = {
        tap = "enabled";
        accel_profile = "adaptive";
      };
    };
    seat.seat0 = {
      xcursor_theme =
        lib.mkIf (config.home.pointerCursor != null)
        "${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}";
      hide_cursor = "3000";
    };
    colors = {
      focused = {
        background = "#${clrs.normal.black}";
        border = "#${clrs.extra.overlay0}";
        childBorder = "#${clrs.extra.overlay0}";
        indicator = "#${clrs.extra.overlay0}";
        text = "#${clrs.default.foreground}";
      };
      unfocused = {
        background = "#${clrs.extra.nocturne}";
        border = "#${clrs.extra.overlay0}";
        childBorder = "#${clrs.extra.overlay0}";
        indicator = "#${clrs.extra.overlay0}";
        text = "#${clrs.extra.overlay1}";
      };
      focusedInactive = {
        background = "#${clrs.extra.nocturne}";
        border = "#${clrs.extra.overlay0}";
        childBorder = "#${clrs.extra.overlay0}";
        indicator = "#${clrs.extra.overlay0}";
        text = "#${clrs.default.foreground}";
      };
    };

    modes.resize = {
      "${left}" = "resize shrink width 10px"; # Pressing left will shrink the window’s width.
      "${right}" = "resize grow width 10px"; # Pressing right will grow the window’s width.
      "${up}" = "resize shrink height 11px"; # Pressing up will shrink the window’s height.
      "${down}" = "resize grow height 10px"; # Pressing down will grow the window’s height.

      Left = "resize shrink width 10px";
      Down = "resize grow height 10px";
      Up = "resize shrink height 10px";
      Right = "resize grow width 10px";

      # Exit mode
      Return = "mode default";
      Escape = "mode default";
      "${modifier}+r" = "mode default";
    };
    modes.passthrough = {
      # Exit mode
      "Shift+Escape" = "mode default";
      "${modifier}+Shift+r" = "mode default";
    };

    focus.wrapping = "workspace";
    focus.newWindow = "urgent";
    defaultWorkspace = "1";
    bars = [{mode = "invisible";}];
    workspaceOutputAssign = [
      {
        output = "eDP-1";
        workspace = "1";
      }
      {
        output = "HDMI-A-1";
        workspace = "2";
      }
      {
        output = "HDMI-A-1";
        workspace = "3";
      }
      {
        output = "HDMI-A-1";
        workspace = "4";
      }
      {
        output = "HDMI-A-1";
        workspace = "5";
      }
      {
        output = "HDMI-A-1";
        workspace = "6";
      }
      {
        output = "HDMI-A-1";
        workspace = "7";
      }
    ];
  };
}