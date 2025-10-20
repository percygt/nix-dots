{
  pkgs,
  lib,
  config,
  ...
}:
let
  t = config.modules.themes;
  f = config.modules.fonts.interface;
  niri = config.modules.desktop.niri.package;
  logincfg = pkgs.writeText "niri-login.conf" ''
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

  persistSystem.directories = [
    {
      directory = "/var/lib/regreet";
      user = "greeter";
      group = "greeter";
      mode = "0755";
    }
  ];

  security.pam.services.greetd.enableGnomeKeyring = true;
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = lib.concatStringsSep " " [
        "${lib.getExe' pkgs.dbus "dbus-run-session"} --"
        "${lib.getExe niri} -c ${logincfg} --"
        "${lib.getExe pkgs.regreet};"
        "${lib.getExe niri} msg action quit --skip-confirmation"
      ];
    };
  };
}
