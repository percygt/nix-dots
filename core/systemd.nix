{
  pkgs,
  username,
  ...
}:
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
  systemd = {
    services."notify-failure@" = {
      enable = true;
      serviceConfig.User = username;
      environment.SERVICE = "%i";
      script = ''
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/''${UID}/bus"
        TITLE=$(echo $SERVICE |  tr "-" " " | sed "s/.*/\L&/; s/[a-z']*/\u&/g")
        ${pkgs.libnotify}/bin/notify-send -i emblem-error -u critical "$TITLE Service" "FAILED to start!. Run journalctl -u $SERVICE for details"
      '';
    };
    services."notify-success@" = {
      enable = true;
      serviceConfig.User = username;
      environment.SERVICE = "%i";
      script = ''
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/''${UID}/bus"
        TITLE=$(echo $SERVICE |  tr "-" " " | sed "s/.*/\L&/; s/[a-z']*/\u&/g")
        ${pkgs.libnotify}/bin/notify-send -i emblem-default "$TITLE Service" "Successfully started."
      '';
    };
    settings.Manager = {
      DefaultTimeoutStopSec = 10;
      DefaultTimeoutAbortSec = 10;
    };
  };
}
