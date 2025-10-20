{
  pkgs,
  config,
  lib,
  ...
}:
let
  niri = lib.getExe config.modules.desktop.niri.package;
  pidof = lib.getExe' pkgs.sysvinit "pidof";
  loginctl = lib.getExe' pkgs.systemd "loginctl";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  dimland = lib.getExe pkgs.dimland;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  ddcutil = lib.getExe pkgs.ddcutil;

in
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "lock";
        command = "${pidof} hyprlock || ${lib.getExe config.programs.hyprlock.package} --immediate --no-fade-in";
      }
      {
        event = "before-sleep";
        command = "${loginctl} lock-session";
      }
      {
        event = "after-resume";
        command = "${niri} msg action power-on-monitors; ${systemctl} --user restart waybar";
      }
    ];
    timeouts = [
      {
        timeout = 5; # 15 min
        command = "${dimland} -a 0.5 -o 'HDMI-A-1'; ${ddcutil} set 10 0 --display 1; ${brightnessctl} set 1";
        resumeCommand = "${dimland} stop; ${ddcutil} set 10 80 --display 1; ${brightnessctl} set 80%";
      }
      {
        timeout = 10; # 30 min
        command = "${dimland} stop; ${loginctl} lock-session";
      }
      {
        timeout = 15; # 60 min
        command = "${niri} msg action power-off-monitors";
        resumeCommand = "${niri} msg action power-on-monitors; ${systemctl} --user restart waybar";
      }
    ];
  };
}
