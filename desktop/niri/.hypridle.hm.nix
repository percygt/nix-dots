{
  lib,
  config,
  pkgs,
  ...
}:
let
  niri = lib.getExe config.modules.desktop.niri.package;
  loginctl = lib.getExe' pkgs.systemd "loginctl";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  brightnessctl = lib.getExe pkgs.brightnessctl;
  sleep = lib.getExe' pkgs.coreutils "sleep";
in
{
  services.hypridle = {
    enable = true;
    settings = rec {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = lib.getExe config.programs.hyprlock.package;
        after_sleep_cmd = "${sleep} 1; ${niri} msg action power-on-monitors; ${systemctl} --user restart waybar";
      };

      listener = [
        {
          timeout = 15; # 15 min
          on-timeout = "${pkgs.writers.writeBash "backlight_timeout" ''
            ${brightnessctl} -d intel_backlight -s
            ${brightnessctl} -d intel_backlight set 1%
            ${brightnessctl} -d ddcci1 -s
            ${brightnessctl} -d ddcci1 set 0%
          ''}";
          on-resume = "${pkgs.writers.writeBash "backlight_resume" ''
            ${sleep} 1
            ${brightnessctl} -d intel_backlight -r
            ${brightnessctl} -d ddcci1 -r
          ''}";
        }
        {
          timeout = 30; # 30 min
          on-timeout = "${loginctl} lock-session";
        }
        {
          timeout = 60; # 45 min
          on-timeout = "${niri} msg action power-off-monitors";
          on-resume = general.after_sleep_cmd;
        }
      ];
    };
  };
  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
}
