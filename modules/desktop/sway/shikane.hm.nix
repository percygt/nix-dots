{
  pkgs,
  config,
  lib,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  swaymsg = "${config.modules.desktop.sway.finalPackage}/bin/swaymsg";
in
{
  config = lib.mkIf config.modules.desktop.sway.shikane.enable {
    wayland.windowManager.sway.config.startup = [
      {
        command = "shikane";
        always = true;
      }
    ];
    services.kanshi.enable = lib.mkForce false;
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
  };
}
