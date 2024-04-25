{
  pkgs,
  isGeneric,
  config,
  lib,
  libx,
  ...
}: let
  inherit (libx) colors wallpaper;
  clrs = colors;
  wezterm =
    if isGeneric
    then pkgs.stash.wezterm_wrapped
    else pkgs.stash.wezterm_nightly;
in {
  config = rec {
    modifier = "Mod4";
    up = "k";
    down = "j";
    left = "h";
    right = "l";
    terminal = "${pkgs.wezterm}/bin/wezterm";
    output."*".bg = "${wallpaper} fill";
    inherit (import ./keybindings.nix {inherit modifier pkgs libx lib wezterm up down left right;}) keybindings;
    inherit (import ./startup.nix {inherit config pkgs;}) startup;
    inherit (import ./window.nix) window;

    # workspaceLayout = "tabbed";
    seat.seat0.xcursor_theme =
      lib.mkIf (config.home.pointerCursor != null)
      "${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}";

    # assigns = {
    #   "2" = [{app_id = "brave-browser";}];
    # };
    colors = {
      focused = {
        background = "#${clrs.extra.azure}";
        border = "#${clrs.extra.midnight}";
        childBorder = "#${clrs.normal.black}";
        indicator = "#${clrs.normal.black}";
        text = "#${clrs.bold}";
      };
      unfocused = {
        background = "#${clrs.normal.black}";
        border = "#${clrs.extra.obsidian}";
        childBorder = "#${clrs.normal.black}";
        indicator = "#${clrs.normal.black}";
        text = "#${clrs.default.foreground}";
      };
      focusedInactive = {
        background = "#${clrs.normal.black}";
        border = "#${clrs.extra.obsidian}";
        childBorder = "#${clrs.normal.black}";
        indicator = "#${clrs.normal.black}";
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
