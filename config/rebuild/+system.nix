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
        // {
          inherit (config.environment.sessionVariables) NIX_PATH SSH_AUTH_SOCK;
        };
      serviceConfig = {
        Type = "exec";
        User = "root";
      };
      script = # bash
        ''
          flake_dir="${g.flakeDirectory}"
          stderr() { printf "%s\n" "$*" >&2; }
          printf "                                                                                                 \n"
          printf "                                                                                                 \n"
          printf "   ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗    ██████╗ ███████╗██████╗ ██╗   ██╗██╗██╗     ██████╗ \n"
          printf "   ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝    ██╔══██╗██╔════╝██╔══██╗██║   ██║██║██║     ██╔══██╗\n"
          printf "   ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗    ██████╔╝█████╗  ██████╔╝██║   ██║██║██║     ██║  ██║\n"
          printf "   ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║    ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██║██║     ██║  ██║\n"
          printf "   ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║    ██║  ██║███████╗██████╔╝╚██████╔╝██║███████╗██████╔╝\n"
          printf "   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝  ╚═╝╚══════╝╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝ \n"
          printf "                                                                                                 \n"
          printf "                                                                                                 \n"
          if [ ! -d "$flake_dir" ] || [ ! -f "$flake_dir/flake.nix" ]; then
            stderr "Flake directory: '$flake_dir' is not valid"
            exit 1
          fi
          # Execute the commands
          cmd_build="nom build $flake_dir#nixosConfigurations.${profile}.config.system.build.toplevel --out-link /tmp/nixos-configuration --accept-flake-config"
          cmd_nvd="nvd diff /run/current-system /tmp/nixos-configuration"
          su - ${username} -c "bash -c '$cmd_build && $cmd_nvd'" && /tmp/nixos-configuration/bin/switch-to-configuration switch || exit 1
        '';
    };
  };
}
