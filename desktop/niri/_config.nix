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
  modules.fileSystem.persist = {
    userData = {
      directories = [ ".local/share/keyrings" ];
      files = [ ".local/state/tofi-drun-history" ];
    };
  };

  imports = [ inputs.niri.nixosModules.niri ];

  programs.niri = {
    enable = true;
    inherit (cfg) package;
  };

  security = {
    pam.services.hyprlock.text = "auth include login";
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  systemd.user.services.niri-flake-polkit.enable = lib.mkForce false;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config =
      let
        common = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Access" = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
          "org.freedesktop.impl.portal.Screenshot" = "gnome";
          "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        };
      in
      {
        inherit common;
        niri = common;
      };
    configPackages = [ config.modules.desktop.niri.package ];
  };
  environment.systemPackages = with pkgs; [
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
      # gnome-settings-daemon.enable = true;
      gnome-keyring.enable = true;
    };
  };
}
