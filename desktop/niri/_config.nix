{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.desktop.niri;
in
{
  persistHome = {
    directories = [
      ".local/share/keyrings"
      ".local/cache/elephant"
    ];
    files = [ ".local/state/tofi-drun-history" ];
  };

  hardware.graphics.enable = lib.mkDefault true;
  programs.dconf.enable = lib.mkDefault true;
  fonts.enableDefaultPackages = lib.mkDefault true;

  security = {
    pam.services.hyprlock.text = "auth include login";
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  environment.systemPackages = with pkgs; [
    cfg.package
    cfg.xwaylandPackage
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    xdg-utils
    wl-clipboard
    wayland-utils
    libsecret
  ];

  services = {
    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [
        dconf
        xfconf
        gcr
        gnome-settings-daemon
        libsecret
      ];
    };
    gnome = {
      gnome-settings-daemon.enable = true;
      gnome-keyring.enable = true;
    };
  };
}
