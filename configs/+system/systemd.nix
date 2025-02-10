{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.isd ];
  services = {
    # Use power button to sleep instead of poweroff
    logind.powerKey = "suspend";
    logind.powerKeyLongPress = "poweroff";
    journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };
  };
  systemd.extraConfig = ''
    [Manager]
    DefaultTimeoutStopSec=10
    DefaultTimeoutAbortSec=10
  '';
}
