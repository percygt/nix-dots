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
    ./rofi
    ./mako.nix
    ./services.nix
    ./i3-quickterm.nix
    ./kanshi.nix
    ./packages.nix
    ./swayidle.nix
    ./swaylock.nix
    ./wpapered.nix
  ];
  services.caffeine.enable = true;
  xsession.importedVariables = ["PATH"];
  wayland.windowManager.sway = {
    enable = true;
    swaynag.enable = true;
    systemd.enable = true;
    systemd.xdgAutostart = true;
    inherit (import ./extraConfig.nix) extraConfig;
    inherit (import ./extraSessionCommands.nix) extraSessionCommands;
    inherit (import ./config.nix {inherit pkgs config lib libx isGeneric;}) config;
    wrapperFeatures = {
      gtk = true;
    };
  };
}
