{
  pkgs,
  lib,
  inputs,
  config,
  username,
  ...
}:
let
  cfg = config.modules.desktop.niri;
in
{
  imports = [ inputs.niri.nixosModules.niri ];
  modules.fileSystem.persist = {
    userData = {
      directories = [
        ".local/share/keyrings"
        ".config/goa-1.0"
      ];
      files = [ ".local/state/tofi-drun-history" ];
    };
  };

  programs.niri = {
    enable = true;
    inherit (cfg) package;
  };

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
  };
  systemd.user.services.niri-flake-polkit.enable = lib.mkForce false;
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config =
      let
        common = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
          "org.freedesktop.impl.portal.Screenshot" = "gnome";
          "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      in
      {
        inherit common;
        niri = common;
      };
    configPackages = [ config.modules.desktop.niri.package ];
  };
  environment = {
    systemPackages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-utils
      wl-clipboard
      wayland-utils
      libsecret
      xwayland-satellite-unstable
    ];
  };
  # services = {
  #   displayManager = {
  #     autoLogin.enable = true;
  #     autoLogin.user = username;
  #     defaultSession = "niri";
  #     sessionPackages = lib.mkForce [
  #       config.modules.desktop.niri.package
  #     ];
  #   };
  # };
  services = {
    dbus = {
      enable = true;
      implementation = "broker";
      # implementation = "dbus";
      packages = with pkgs; [
        dconf
        xfce.xfconf
        gcr
        gnome-settings-daemon
        libsecret
      ];
    };
  };
}
