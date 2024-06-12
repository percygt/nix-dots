{config, ...}: let
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
in {
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "solo";
          exec = ["${swaymsg} bar bar-1 mode dock"];
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        };
      }
      {
        profile = {
          name = "with-monitor";
          exec = ["${swaymsg} bar bar-1 mode invisible"];
          outputs = [
            {
              criteria = "HDMI-A-1";
              mode = "1920x1080@60Hz";
              position = "0,0";
              status = "enable";
            }
            {
              criteria = "eDP-1";
              position = "0,1080";
              status = "enable";
            }
          ];
        };
      }
    ];
  }; # END kanshi
}
