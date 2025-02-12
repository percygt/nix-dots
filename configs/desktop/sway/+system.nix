{
  pkgs,
  config,
  username,
  lib,
  ...
}:
let
  g = config._base;
  unsupported-gpu = lib.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  imports = [
    ./regreet.nix
    # ./tuigreet.nix
  ];

  modules.core.persist.userData = {
    directories = [
      ".local/share/keyrings"
      ".config/goa-1.0"
      ".local/cache/nix-index"
    ];
    files = [ ".local/state/tofi-drun-history" ];
  };
  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      NIXOS_OZONE_WL = "1";
    };
  };
  programs = {
    sway = {
      enable = true;
      package = g.desktop.sway.finalPackage;
      wrapperFeatures.gtk = true;
    };
  };

  # # Make sure to start the home-manager activation before I log in.
  # systemd.services."home-manager-${username}" = {
  #   before = [ "display-manager.service" ];
  #   wantedBy = [ "multi-user.target" ];
  # };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr = {
      enable = true;
      settings.screencast = {
        output_name = "eDP-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or -s '#99d1ce33'";
      };
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment = {
    systemPackages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-utils
    ];
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock.text = "auth include login";
  };

  services = {
    dbus = {
      enable = true;
      implementation = "broker";
      # implementation = "dbus";
      packages = with pkgs; [
        dconf
        xfce.xfconf
      ];
    };
    gnome = {
      gnome-settings-daemon.enable = true;
      gnome-keyring.enable = true;
    };
  };
}
