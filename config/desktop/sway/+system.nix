{
  pkgs,
  config,
  lib,
  username,
  ...
}:
let
  g = config._base;
in
{
  imports = [ ./regreet.nix ];
  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      NIXOS_OZONE_WL = "1";
    };
    persistence = lib.mkIf config.modules.core.ephemeral.enable {
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
  };
  programs = {
    sway = {
      enable = true;
      inherit (g.desktop.sway) package;
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
