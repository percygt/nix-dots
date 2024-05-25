{
  pkgs,
  libx,
  username,
  ...
}: {
  imports = [
    ./tuigreet.nix
  ];
  programs = {
    seahorse.enable = true;
    sway = {
      enable = true;
      package = libx.sway.package {inherit pkgs;};
      wrapperFeatures.gtk = true;
    };
  };

  # Make sure to start the home-manager activation before I log in.
  systemd.services."home-manager-${username}" = {
    before = ["display-manager.service"];
    wantedBy = ["multi-user.target"];
  };

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings.screencast = {
        output_name = "eDP-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or -s '#99d1ce33'";
      };
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  environment.etc."greetd/environments".text = ''
    sway
    fish
  '';

  security = {
    polkit.enable = true;
    pam.services.swaylock.text = "auth include login";
  };
  services = {
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [
        gcr
        gnome.gnome-settings-daemon
        dconf
        gnome.gnome-keyring
      ];
    };
    gnome = {
      gnome-keyring.enable = true;
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-online-accounts.enable = true;
    };
  };
}
