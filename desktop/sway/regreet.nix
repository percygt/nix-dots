{
  pkgs,
  lib,
  config,
  ...
}:
let
  t = config.modules.themes;
  f = config.modules.fonts.interface;
  cfg = config.modules.desktop.sway;
  sway-kiosk =
    command:
    "${cfg.command} --config ${pkgs.writeText "kiosk.config" ''
      output * bg #000000 solid_color
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

  modules.fileSystem.persist.systemData.directories = [
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
