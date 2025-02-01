{
  pkgs,
  lib,
  config,
  ...
}:
let
  t = config.modules.themes;
  f = config.modules.fonts.interface;
  g = config._base;

  sway-kiosk =
    command:
    "${g.desktop.sway.command} --config ${pkgs.writeText "kiosk.config" ''
      exec '${command}; swaymsg exit'
      include /etc/sway/config.d/*

      bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
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

  modules.core.persist.systemData.directories = [
    {
      directory = "/var/lib/regreet";
      user = "greeter";
      group = "greeter";
      mode = "0755";
    }
  ];

  environment = {
    etc = {
      "greetd/environments".text = ''
        sway
        bash
        fish
      '';
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = sway-kiosk (lib.getExe config.programs.regreet.package);
    };
  };
}
