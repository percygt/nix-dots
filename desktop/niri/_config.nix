{
  pkgs,
  lib,
  inputs,
  ...
}:
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
    package = pkgs.niri-stable;
  };

  systemd.user.services.niri-flake-polkit.enable = lib.mkForce false;
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
        "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };
  environment = {
    systemPackages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-utils
      wl-clipboard
      wayland-utils
      libsecret
      cage
      gamescope
      xwayland-satellite-unstable
    ];
  };
  services.displayManager.defaultSession = "niri";
  services = {
    dbus = {
      enable = true;
      implementation = "broker";
      # implementation = "dbus";
      packages = with pkgs; [
        dconf
        xfce.xfconf
        gcr
      ];
    };
  };
}
