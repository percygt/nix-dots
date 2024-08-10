{ pkgs, ... }:
{
  imports = [
    ./waybar
    ./swaync
    ./services.nix
    ./i3-quickterm.nix
    ./kanshi.nix
    ./packages.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swappy.nix
    ./tofi.nix
    ./config.nix
    ./extraConfig.nix
    ./extraSessionCommands.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    swaynag.enable = true;
    systemd.enable = true;
    systemd.xdgAutostart = true;
    wrapperFeatures.gtk = true;
    checkConfig = false;
  };
}
