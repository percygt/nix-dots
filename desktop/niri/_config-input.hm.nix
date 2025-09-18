{
  config,
  pkgs,
  inputs,
  homeDirectory,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.niri;
  g = config._global;
  a = config.modules.themes.assets;
  f = config.modules.fonts.app;
  c = config.modules.themes.colors.withHashtag;
  inherit (config.modules.themes)
    cursorTheme
    iconTheme
    gtkTheme
    ;
in
{
  programs.niri.settings.input = {
    keyboard.xkb.layout = "us";
    touchpad = {
      tap = true;
      dwt = true;
      dwtp = true;
      click-method = "button-areas";
      natural-scroll = true;
      scroll-method = "two-finger";
      tap-button-map = "left-right-middle";
      middle-emulation = true;
      accel-profile = "adaptive";
    };
    mouse = {
      accel-speed = 0.1;
    };
    focus-follows-mouse = {
      enable = true;
      max-scroll-amount = "0%";
    };
    warp-mouse-to-focus.enable = true;
    workspace-auto-back-and-forth = true;
  };
}
