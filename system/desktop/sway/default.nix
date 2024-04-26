{pkgs, ...}: {
  imports = [
    ./xremap.nix
    ./cursor.nix
    ./tuigreet.nix
  ];
  programs = {
    sway = {
      enable = true;
      package = pkgs.swayfx.overrideAttrs (_: {passthru.providedSessions = ["sway"];});
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
        output_name = "DP-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or -s '#99d1ce33'";
      };
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  nix.settings = {
    substituters = ["https://nixpkgs-wayland.cachix.org"];
    trusted-public-keys = ["nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="];
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
  };
}
