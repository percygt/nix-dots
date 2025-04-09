{ lib, config, ... }:
let
  swaymsg = "${config._base.desktop.sway.finalPackage}/bin/swaymsg";
in
{
  wayland.windowManager.sway.config.startup = lib.mkIf config.services.kanshi.enable [
    {
      command = "kanshi";
      always = true;
    }
  ];
  systemd.user.services.kanshi = lib.mkForce { };
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "solo";
          exec = [ "${swaymsg} bar bar-1 mode dock" ];
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
          exec = [ "${swaymsg} bar bar-1 mode invisible" ];
          outputs = [
            {
              criteria = "HDMI-A-1";
              mode = "1920x1080@99.999Hz";
              position = "0,0";
              status = "enable";
            }
            {
              criteria = "eDP-1";
              position = "1920,0";
              scale = 1.25;
              status = "enable";
            }
          ];
        };
      }
    ];
  }; # END kanshi
}
