# Run automatic updates. Replaces system.autoUpgrade.
{
  config,
  lib,
  username,
  pkgs,
  ...
}:

let
  g = config._base;
  cfg = config.modules.core.autoupgrade;
  inherit (config._base) flakeDirectory;
in
{
  config = lib.mkIf cfg.enable {
    # Assert that system.autoUpgrade is not also enabled
    assertions = [
      {
        assertion = !config.system.autoUpgrade.enable;
        message = "The system.autoUpgrade option conflicts with this module.";
      }
    ];

    # Pull and apply updates.
    systemd.services.nixos-upgrade = {
      serviceConfig = {
        Type = "oneshot";
        User = username;
      };
      environment = {
        inherit (config.environment.sessionVariables) SSH_AUTH_SOCK;
      };
      onFailure = [ "notify-failure@%i.service" ];
      onSuccess = [ "notify-success@%i.service" ];
      path = g.system.envPackages;
      preStart = ''
        uid=$(id -u ${username})
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus"
        su "${username}" -c "notify-send -i system-software-update 'Nixos Upgrade Service' 'Starting nixos upgrade and rebuild'"
        sleep 10
      '';
      script = ''
        cd ${flakeDirectory}
        # Check if there are changes from Git.
        git fetch
        echo "Pulling latest version..."

        if ! [[ $(git status) =~ "working tree clean" ]]; then
          git add .
          git commit -m "auto commit"
        fi
        # Get the current local commit hash and the latest remote commit hash
        LOCAL_HASH=$(git rev-parse HEAD)
        REMOTE_HASH=$(git rev-parse @{u})

        if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
          echo "Updates found, running nixos-rebuild..."
          git pull
          exec systemctl start nixos-rebuild
        else
          echo "No updates found. Exiting."
          export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus"
          su "${username}" -c "notify-send -i zen-icon 'Nixos Upgrade Service' 'No updates found. Exiting.'"
        fi
      '';
    };
    systemd.timers."nixos-upgrade" = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.onCalendar;
        Persistent = cfg.persistent;
        Unit = "nixos-upgrade.service";
      };
    };
  };
}
