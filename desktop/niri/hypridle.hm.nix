{
  lib,
  config,
  pkgs,
  ...
}:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # ignore_dbus_inhibit = false;
        lock_cmd = lib.getExe config.programs.hyprlock.package;
        # before_sleep_cmd = "pidof hyprlock || hyprlock";
        # after_sleep_cmd = "sleep 0.5; niri msg action power-on-monitors";
      };

      listener = [
        {
          timeout = 5 * 60; # 5 min
          on-timeout = "backlightset min";
          on-resume = "backlightset max";
        }
        {
          timeout = 30 * 60; # 15 min
          on-timeout = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
        }
        {
          timeout = 60 * 60; # 60 min
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "sleep 0.5; niri msg action power-on-monitors";
        }
        # {
        #   timeout = 6 * 60 * 60; # 6 hrs
        #   on-timeout = "systemctl suspend";
        # }
      ];
    };
  };
}
