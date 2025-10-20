{ pkgs, lib, ... }:
let
  brightnessctl = lib.getExe pkgs.brightnessctl;
  # timeouts
  toDim = 60 * 15; # 15 minutes
  toLock = 60 * 30; # 30 minutes
  toScreenOff = 60 * 45; # 45 minutes
  toSuspend = 60 * 60; # 60 minutes
  cmdDim = "${pkgs.writers.writeBash "backlight_dim" ''
    ${brightnessctl} -d intel_backlight -s
    ${brightnessctl} -d intel_backlight set 1%
    ${brightnessctl} -d ddcci1 -s
    ${brightnessctl} -d ddcci1 set 0%
  ''}";
  cmdBacklightRestore = "${pkgs.writers.writeBash "backlight_restore" ''
    ${brightnessctl} -d intel_backlight -r
    ${brightnessctl} -d ddcci1 -r
  ''}";
  cmdLock = "pgrep -x hyprlock > /dev/null || hyprlock &";
  cmdScreenOff = "niri msg action power-off-monitors";
  cmdSuspend = "systemctl suspend";
  cmdResumeSuspend = "systemctl --user reset-failed waybar";
  swayidleCommand =
    "${lib.getExe pkgs.swayidle} -w"
    + " timeout ${toString toDim} '${cmdDim}'"
    + " resume '${cmdBacklightRestore}'"
    + " timeout ${toString toLock} '${cmdLock}'"
    + " timeout ${toString toScreenOff} '${cmdScreenOff}'"
    # + " resume '${cmdResumeSuspend}'"
    # + " timeout ${toString toSuspend} '${cmdSuspend}'"
    + " before-sleep '${cmdLock}'";
in
{
  systemd.user.services.swayidle = {
    Unit = {
      Description = "Idle/screen lock daemon for Wayland";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = swayidleCommand;
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
