{
  pkgs,
  ...
}:
{
  modules.fileSystem.persist.userData = {
    directories = [
      ".local/share/keyrings"
      ".config/goa-1.0"
    ];
    files = [ ".local/state/tofi-drun-history" ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wl-clipboard
      wayland-utils
      libsecret
      cage
      gamescope
      xwayland-satellite-unstable
    ];
  };

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
