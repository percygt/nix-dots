{
  pkgs,
  lib,
  config,
  ...
}:
let
  t = config.modules.theme;
  f = config.modules.fonts.interface;
  g = config._general;
  swayPkg = g.desktop.sway.package;
  homeCfgs = config.home-manager.users;
  unsupported-gpu = lib.elem "nvidia" config.services.xserver.videoDrivers;
  xSessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions";
  wlSessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
  homeSharePaths = lib.mapAttrsToList (_: v: "${v.home.path}/share") homeCfgs;
  vars = ''XDG_DATA_DIRS="$XDG_DATA_DIRS:${lib.concatStringsSep ":" homeSharePaths}" SESSION_DIRS=${xSessions}:${wlSessions} GTK_USE_PORTAL=0'';

  sway-kiosk =
    command:
    "${lib.getExe swayPkg} ${lib.optionalString unsupported-gpu "--unsupported-gpu"} --config ${pkgs.writeText "kiosk.config" ''
      output * bg #000000 solid_color
      xwayland disable
      input "type:touchpad" {
        tap enabled
      }
      exec '${vars} ${command}; ${swayPkg}/bin/swaymsg exit'
    ''}";
in
{
  programs.regreet = {
    enable = true;
    inherit (t) iconTheme;
    cursorTheme = {
      inherit (t.cursorTheme) name package;
    };
    font = {
      inherit (f) name package;
      size = builtins.floor f.size;
    };
    theme = t.gtkTheme;
    settings.background = {
      path = t.assets.wallpaper;
      fit = "Cover";
    };
  };
  environment = {

    etc."greetd/environments".text = ''
      sway
      fish
    '';
    persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist/system".directories = [
        {
          directory = "/var/cache/regreet";
          user = "greeter";
          group = "greeter";
          mode = "0755";
        }
      ];
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
  services.greetd = {
    enable = true;
    settings.default_session.command = sway-kiosk (lib.getExe config.programs.regreet.package);
  };
}
