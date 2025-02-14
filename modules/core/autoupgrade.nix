# Run automatic updates. Replaces system.autoUpgrade.
{
  config,
  lib,
  username,
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
      path = g.system.envPackages;
      preStart = ''
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/''${UID}/bus"
        notify-send -i system-software-update 'Nixos Upgrade Service' 'Upgrade is about to start.'
        sleep 10
      '';
      script = ''
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/''${UID}/bus"
        cd ${flakeDirectory}
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
          git pull && \
            systemctl start nixos-rebuild.service && \
              notify-send -i system-software-update "Nixos Upgrade Service" "System upgrade was completed successfully."
        else
          notify-send -i system-software-update "Nixos Upgrade Service" "No updates found. Exiting."
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
