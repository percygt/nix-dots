{
  pkgs,
  libx,
  ...
}: {
  imports = [
    ./cursor.nix
    ./tuigreet.nix
  ];
  programs = {
    sway = {
      enable = true;
      package = libx.sway.package {inherit pkgs;};
      wrapperFeatures.gtk = true;
    };
    dconf.enable = true;
    file-roller.enable = true;
    gnome-disks.enable = true;
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
    gvfs.enable = true;
    dbus = {
      enable = true;
      implementation = "broker";
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
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-online-accounts.enable = true;
    };
  };
}
