{
  pkgs,
  lib,
  config,
  isGeneric,
  ...
}:
let
  t = config.modules.theme;
  f = config.modules.fonts.shell;
  inherit (config._general) flakeDirectory;
  c = t.colors.withHashtag;
  moduleWezterm = "${flakeDirectory}/config/terminal/wezterm";
in
{
  xdg.configFile = {
    "wezterm/wezterm.lua".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${moduleWezterm}/wezterm.lua"
    );
    "wezterm/nix.lua".text =
      #lua
      ''
        local wezterm = require("wezterm")
        return {
          font = wezterm.font("${f.name}", { weight = "DemiBold" }),
          font_size = tonumber("${builtins.toString f.size}"),
        	default_prog = { '${lib.getExe pkgs.tmux-launch-session}' }
        }
      '';
  };
  programs.wezterm = {
    enable = true;
    package = if isGeneric then pkgs.wezterm_wrapped else pkgs.wezterm_nightly;
    colorSchemes = {
      Syft = {
        ansi = [
          c.base01
          c.base08 # red
          c.base0B # green
          c.base09 # yellow
          c.base0D # blue
          c.base0E # magenta
          c.base0C # cyan
          c.base06
        ];
        brights = [
          c.base02
          c.base12 # bright red
          c.base14 # bright green
          c.base13 # bright yellow
          c.base16 # bright blue
          c.base17 # bright magenta
          c.base15 # bright cyan
          c.base07
        ];
        foreground = c.base05;
        background = c.base00;
        cursor_bg = c.base05;
        cursor_border = c.base05;
        selection_fg = "none";
        selection_bg = c.base02;
      };
    };
  };
}
