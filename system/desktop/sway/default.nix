{
  pkgs,
  config,
  ...
}: {
  imports = [./xremap.nix];
  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings.screencast = {
        output_name = "DP-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or -s '#99d1ce33'";
      };
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx.overrideAttrs (_: {passthru.providedSessions = ["sway"];});
    wrapperFeatures.gtk = true;
  };

  environment.etc."greetd/environments".text = ''
    sway
    fish
  '';

  programs = {
    dconf.enable = true;
    file-roller.enable = true;
    gnome-disks.enable = true;
  };

  security = {
    polkit.enable = true;
    pam = {
      services = {
        # unlock gnome keyring automatically with greetd
        greetd.enableGnomeKeyring = true;
        swaylock = {
          text = "auth include login";
        };
      };
    };
  };

  services = {
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    gvfs.enable = true;
    dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
        gnome.gnome-settings-daemon
        dconf
        gnome3.gnome-keyring
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --time --remember --remember-user-session";
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
