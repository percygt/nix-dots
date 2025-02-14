{
  config,
  profile,
  username,
  pkgs,
  ...
}:
let
  g = config._base;
in
{
  security.polkit = {
    extraConfig =
      # javascript
      ''
        // Log authorization checks
        polkit.addRule(function(action, subject) {
          polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
        });
        // Allow rebuilds for admin user without password
        polkit.addRule(function(action, subject) {
          polkit.log("action=" + action);
          polkit.log("subject=" + subject);
          var wheel = subject.isInGroup("wheel");
          var systemd = (action.id == "org.freedesktop.systemd1.manage-unit-files");
          var rebuild = (action.lookup("unit") == "nixos-rebuild.service");
          var verb = action.lookup("verb");
          var acceptedVerb = (verb == "start" || verb == "stop" || verb == "restart");
          if (wheel && systemd && rebuild && acceptedVerb) {
            return polkit.Result.YES;
          }
        });
      '';
  };
  systemd = {
    services.nixos-rebuild = {
      restartIfChanged = false;
      path = g.system.envPackages;
      onFailure = [ "notify-failure@%i.service" ];
      onSuccess = [ "notify-success@%i.service" ];
      environment =
        config.nix.envVars
        // config.networking.proxy.envVars
        // config.environment.sessionVariables
        // config.home-manager.users.${username}.home.sessionVariables;
      serviceConfig = {
        Type = "exec";
        User = "root";
      };
      preStart = ''
        uid=$(id -u ${username})
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus"
        su "${username}" -c "notify-send -i zen-icon 'Nixos Rebuild Service' 'NixOS rebuild is about to start'"
        sleep 10
      '';
      script = ''
        stderr() { printf "%s\n" "$*" >&2; }
        if [ ! -d "$FLAKE" ] || [ ! -f "$FLAKE/flake.nix" ]; then
          stderr "Flake directory: $FLAKE is not valid"
          exit 1
        fi

        uid=$(id -u ${username})
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus"

        NIXOSCONFIGDIR="/tmp/nrs-config"
        HMCONFIGDIR="/tmp/hms-config"

        user_exec() {
          su "${username}" -c "$1"
        }

        # Execute the commands
        user_exec \
          "nom build \
          $FLAKE#nixosConfigurations.\"${profile}\".config.system.build.toplevel \
          --out-link \"$NIXOSCONFIGDIR\" \
          --accept-flake-config"

        $NIXOSCONFIGDIR/bin/switch-to-configuration switch || exit 1

        user_exec \
          "nvd diff /run/current-system \"$NIXOSCONFIGDIR\""

        user_exec \
          "nom build \
          $FLAKE#homeConfigurations.\"${username}@${profile}\".config.home.activationPackage \
          --out-link \"$HMCONFIGDIR\" \
          --accept-flake-config"

        user_exec \
          "nvd diff /home/${username}/.local/state/nix/profiles/home-manager \"$HMCONFIGDIR\""

        user_exec \
          "$HMCONFIGDIR/bin/home-manager-generation"
      '';
    };
  };
}
