{
  pkgs,
  libx,
  config,
  lib,
  isGeneric,
  ...
}: let
  swayPkg = libx.sway.package;
in {
  imports = [
    ./waybar
    ./mako.nix
    ./services.nix
    ./i3-quickterm.nix
    ./kanshi.nix
    ./packages.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swappy.nix
    ./tofi.nix
    # ./wpapered.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/wm/preferences".button-layout = ":appmenu";
    "org/gnome/terminal/legacy".default-show-menubar = false;
  };
  nix.settings.substituters = ["https://nixpkgs-wayland.cachix.org"];
  nix.settings.trusted-public-keys = ["nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="];
  xsession.importedVariables = ["PATH"];
  wayland.windowManager.sway = {
    enable = true;
    package = swayPkg pkgs;
    swaynag.enable = true;
    systemd.enable = true;
    systemd.xdgAutostart = true;
    wrapperFeatures.gtk = true;
    inherit (import ./extraConfig.nix) extraConfig;
    inherit (import ./extraSessionCommands.nix) extraSessionCommands;
    inherit (import ./config.nix {inherit pkgs config lib libx isGeneric;}) config;
  };
}
