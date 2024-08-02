{
  pkgs,
  libx,
  username,
  config,
  lib,
  ...
}:
{
  imports = [ ./tuigreet.nix ];
  home-manager.users.${username} = import ./home.nix;
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${username} = {
        directories = [
          ".local/share/keyrings"
          ".config/goa-1.0"
          ".local/cache/nix-index"
        ];
        files = [ ".local/state/tofi-drun-history" ];
      };
    };
  };
  programs = {
    sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
    };
  };

  # Make sure to start the home-manager activation before I log in.
  systemd.services."home-manager-${username}" = {
    before = [ "display-manager.service" ];
    wantedBy = [ "multi-user.target" ];
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
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
    dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [ dconf ];
    };
    gnome = {
      gnome-settings-daemon.enable = true;
      gnome-keyring.enable = true;
    };
  };
}
