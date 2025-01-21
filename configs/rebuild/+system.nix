{
  config,
  profile,
  username,
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
      environment =
        config.nix.envVars
        // config.networking.proxy.envVars
        // config.environment.sessionVariables
        // config.home-manager.users.${username}.home.sessionVariables;
      serviceConfig = {
        Type = "exec";
        User = "root";
      };
      script = # bash
        ''
          stderr() { printf "%s\n" "$*" >&2; }
          if [ ! -d "$FLAKE" ] || [ ! -f "$FLAKE/flake.nix" ]; then
            stderr "Flake directory: $FLAKE is not valid"
            exit 1
          fi

          NIXOSCONFIGDIR="/tmp/nrs-config"
          HMCONFIGDIR="/tmp/hms-config"

          # Execute the commands
          su "${username}" -c \
            "nom build \
            $FLAKE#nixosConfigurations.\"${profile}\".config.system.build.toplevel \
            --out-link \"$NIXOSCONFIGDIR\" \
            --accept-flake-config"

          $NIXOSCONFIGDIR/bin/switch-to-configuration switch || exit 1

          su ${username} -c \
            "nvd diff /run/current-system \"$NIXOSCONFIGDIR\""

          su ${username} -c \
            "nom build \
            $FLAKE#homeConfigurations.\"${username}@${profile}\".config.home.activationPackage \
            --out-link \"$HMCONFIGDIR\" \
            --accept-flake-config"

          su ${username} -c \
            "nvd diff /home/${username}/.local/state/nix/profiles/home-manager \"$HMCONFIGDIR\""

          su ${username} -c \
            "$HMCONFIGDIR/bin/home-manager-generation"
        '';
    };
  };
}
