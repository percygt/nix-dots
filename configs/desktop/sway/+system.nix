{
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.sway;
in
{
  imports = [
    ./regreet.nix
    # ./tuigreet.nix
  ];

  modules.fileSystem.persist.userData = {
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
      package = cfg.finalPackage;
      wrapperFeatures.gtk = true;
    };
  };

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

  security.polkit.enable = true;

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
