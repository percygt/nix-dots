{
  pkgs,
  config,
  lib,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  swaymsg = "${config._base.desktop.sway.finalPackage}/bin/swaymsg";
  kanshiEnabled = config.modules.desktop.sway.kanshi.enable;
in
lib.mkIf (!kanshiEnabled) {
  wayland.windowManager.sway.config.startup = [
    {
      command = "shikane";
      always = true;
    }
  ];
  home.packages = [ pkgs.shikane ];
  xdg.configFile = {
    "shikane/config.toml".source = tomlFormat.generate "config.toml" {
      profile = [
        {
          name = "solo";
          exec = [ "${swaymsg} bar bar-1 mode dock" ];
          output = [
            {
              search = "eDP-1";
              enable = true;
            }
          ];
        }
        {
          name = "with-monitor";
          exec = [ "${swaymsg} bar bar-1 mode invisible" ];
          output = [
            {
              search = "HDMI-A-1";
              position = "0,0";
              mode = "1920x1080@99.999Hz";
              enable = true;
            }
            {
              search = "eDP-1";
              position = "1920,0";
              scale = 1.5;
              enable = true;
            }
          ];
        }
      ];
    };
  };
}
