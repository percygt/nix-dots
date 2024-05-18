{
  pkgs,
  libx,
  config,
  lib,
  isGeneric,
  ...
}: {
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

  xsession.importedVariables = ["PATH"];
  wayland.windowManager.sway = {
    enable = true;
    package = libx.sway.package {inherit pkgs;};
    swaynag.enable = true;
    systemd.enable = true;
    systemd.xdgAutostart = true;
    wrapperFeatures.gtk = true;
    checkConfig = false;
    inherit (import ./extraConfig.nix) extraConfig;
    inherit (import ./extraSessionCommands.nix) extraSessionCommands;
    inherit (import ./config.nix {inherit pkgs config lib libx isGeneric;}) config;
  };
}
