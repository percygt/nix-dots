{
  pkgs,
  config,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  swaymsg = "${config._base.desktop.sway.finalPackage}/bin/swaymsg";
in
{
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
              search = "DP-4";
              position = "0,0";
              enable = true;
            }
            {
              search = "eDP-1";
              position = "1920,0";
              enable = true;
            }
          ];
        }
        # {
        #   name = "with-monitor";
        #   exec = [ "${swaymsg} bar bar-1 mode invisible" ];
        #   output = [
        #     {
        #       search = "HDMI-A-1";
        #       mode = "1920x1080@99.999Hz";
        #       position = "0,0";
        #       enable = true;
        #     }
        #     {
        #       search = "eDP-1";
        #       position = "0,1080";
        #       enable = true;
        #     }
        #   ];
        # }
      ];
    };
  };
}
