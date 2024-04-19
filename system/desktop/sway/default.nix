{
  pkgs,
  username,
  config,
  ...
}: {
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  systemd.services."home-manager-${username}" = {
    before = ["display-manager.service"];
    wantedBy = ["multi-user.target"];
  };
  security.polkit.enable = true;
  programs = {
    dconf.enable = true;
    file-roller.enable = true;
  };
  security = {
    pam = {
      services = {
        # unlock gnome keyring automatically with greetd
        greetd.enableGnomeKeyring = true;
      };
    };
  };
  services = {
    # gvfs.enable = true;
    dbus = {
      enable = true;
      # Make the gnome keyring work properly
      packages = [
        pkgs.gnome3.gnome-keyring
        pkgs.gcr
      ];
    };

    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
          user = "greeter";
        };
      };
    };
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
