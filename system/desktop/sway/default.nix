{
  pkgs,
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

  environment.etc."greetd/environments".text = ''
    sway
    fish
  '';

  programs = {
    dconf.enable = true;
    file-roller.enable = true;
  };

  security = {
    polkit.enable = true;
    pam = {
      services = {
        # unlock gnome keyring automatically with greetd
        greetd.enableGnomeKeyring = true;
      };
    };
  };

  services = {
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    gvfs.enable = true;
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions --time --remember --remember-user-session";
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
