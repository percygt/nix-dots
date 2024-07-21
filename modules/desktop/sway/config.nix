{
  pkgs,
  configx,
  config,
  lib,
  libx,
  ...
}:
let
  inherit (libx) sway;
  inherit (sway) mkAppsFloat;
  inherit (configx) assets;
  f = config.setFonts.interface;
  c = config.setTheme.colors.withHashtag;
in
{
  config = rec {
    fonts = {
      names = [ f.name ];
      inherit (f) style size;
    };
    modifier = "Mod4";
    up = "k";
    down = "j";
    left = "h";
    right = "l";
    terminal = "${pkgs.foot}/bin/foot";
    output."*".bg = "${pkgs.fetchurl assets.wallpaper} fill";
    gaps.inner = 4;
    inherit
      (import ./keybindings.nix {
        inherit
          modifier
          pkgs
          libx
          lib
          configx
          config
          up
          down
          left
          right
          terminal
          ;
      })
      keybindings
      ;
    inherit (import ./startup.nix) startup;
    inherit (import ./window.nix { inherit mkAppsFloat; }) window;
    input = {
      "type:keyboard".xkb_layout = "us";
      "type:pointer".accel_profile = "adaptive";
      "type:touchpad" = {
        tap = "enabled";
        accel_profile = "adaptive";
      };
    };
    seat.seat0 = {
      xcursor_theme = lib.mkIf (
        config.home.pointerCursor != null
      ) "${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}";
      hide_cursor = "3000";
    };
    colors = {
      focused = {
        background = c.base00;
        border = c.base03;
        childBorder = c.base03;
        indicator = c.base03;
        text = c.base05;
      };
      unfocused = {
        background = c.base02;
        border = c.base03;
        childBorder = c.base03;
        indicator = c.base03;
        text = c.base04;
      };
      focusedInactive = {
        background = c.base02;
        border = c.base03;
        childBorder = c.base03;
        indicator = c.base03;
        text = c.base05;
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

    # focus.wrapping = "workspace";
    focus.newWindow = "urgent";
    defaultWorkspace = "0-home";
    bars = [
      {
        command = lib.getExe config.programs.waybar.package;
        mode = "dock";
        hiddenState = "show";
        position = "top";
      }
      {
        id = "bar-1";
        command = "true";
        position = "bottom";
      }
    ];
    workspaceOutputAssign = [
      {
        workspace = "0-home";
        output = "eDP-1";
      }
      {
        workspace = "1";
        output = "HDMI-A-1";
      }
      {
        workspace = "2";
        output = "HDMI-A-1";
      }
      {
        workspace = "3";
        output = "HDMI-A-1";
      }
      {
        workspace = "4";
        output = "HDMI-A-1";
      }
      {
        workspace = "5";
        output = "HDMI-A-1";
      }
    ];
  };
}
