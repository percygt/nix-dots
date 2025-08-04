{
  pkgs,
  lib,
  config,
  ...
}:
let
  t = config.modules.themes;
  f = config.modules.fonts.interface;
  logincfg = pkgs.writeText "niri-login.conf" ''
    animations {
      off
    }
    hotkey-overlay {
      skip-at-startup
    }
    window-rule {
      open-focused true
    }
  '';
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

  modules.fileSystem.persist.systemData.directories = [
    {
      directory = "/var/lib/regreet";
      user = "greeter";
      group = "greeter";
      mode = "0755";
    }
  ];

  security.pam.services.greetd.enableGnomeKeyring = true;
  services.displayManager.defaultSession = "niri";
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = lib.concatStringsSep " " [
        "${lib.getExe' pkgs.dbus "dbus-run-session"} --"
        "${lib.getExe pkgs.niri} -c ${logincfg} --"
        "${lib.getExe pkgs.greetd.regreet};"
        "${lib.getExe pkgs.niri} msg action quit --skip-confirmation"
      ];
    };
  };
}
