{ config, ... }:
let
  g = config._base;
in
{

  imports = [
    ./dconf.nix
    ./pomo.nix
    ./waybar
    ./cliphist.nix
    ./kanshi.nix
    ./swaync
    ./wlsunset.nix
    ./wayland-pipewire-idle-inhibit.nix
    ./polkit-gnome-authentication.nix
    ./ddapp.nix
    ./extraPackages.nix
    ./swayidle.nix
    ./swappy.nix
    ./tofi.nix
    ./sway-config.nix
    ./sway-extraConfig.nix
    ./sway-extraSessionCommands.nix
  ];
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    NIXOS_OZONE_WL = "1";
  };
  wayland.windowManager.sway = {
    enable = true;
    package = g.desktop.sway.finalPackage;
    swaynag.enable = true;
    systemd.xdgAutostart = true;
    wrapperFeatures.gtk = true;
    checkConfig = false;
  };
}
