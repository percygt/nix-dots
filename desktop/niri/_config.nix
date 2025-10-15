{
  pkgs,
  lib,
  inputs,
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

  # imports = [ inputs.niri.nixosModules.niri ];
  #
  # programs.niri = {
  #   enable = true;
  #   inherit (cfg) package;
  # };
  hardware.graphics.enable = lib.mkDefault true;
  programs.dconf.enable = lib.mkDefault true;
  fonts.enableDefaultPackages = lib.mkDefault true;

  security = {
    pam.services.hyprlock.text = "auth include login";
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  systemd.user.services.niri-flake-polkit.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    cfg.package
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
        xfce.xfconf
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
