{
  lib,
  config,
  profile,
  ...
}:
let
  g = config._general;
in
{
  home-manager.users.${g.username} =
    { pkgs, ... }:
    {
      systemd.user.services.nixos-rebuild = {
        Service = {
          Type = "exec";
          ExecStart = lib.getExe (
            pkgs.writeShellApplication {
              name = "nixos-rebuild-exec-start";
              runtimeInputs = g.envPackages;
              text = ''
                notify_success() {
                  notify-send -i emblem-default "System Rebuild" "NixOS rebuild successful"
                  { mpv ${pkgs.success-alert} || true; } &
                  sleep 5 && kill -9 "$!"
                }
                notify_failure() {
                  notify-send --urgency=critical -i emblem-error "System Rebuild" "NixOS rebuild failed!"
                  { mpv ${pkgs.failure-alert} || true; } &
                  sleep 5 && kill -9 "$!"
                }
                if systemctl start nixos-rebuild.service; then
                  notify-send -i zen-icon "System Rebuild" "NixOS rebuild switch started"
                  while systemctl -q is-active nixos-rebuild.service; do
                    sleep 1
                  done
                  if systemctl -q is-failed nixos-rebuild.service; then
                    notify_failure
                  else
                    notify_success
                  fi
                else
                  notify_failure
                fi
              '';
            }
          );
        };
      };
    };
  security.polkit = {
    debug = true;
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
      path = g.envPackages;
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
          printf "  ===============================================================================================\n"
          printf "                                                                                                 \n"
          printf "   ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗    ██████╗ ███████╗██████╗ ██╗   ██╗██╗██╗     ██████╗ \n"
          printf "   ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝    ██╔══██╗██╔════╝██╔══██╗██║   ██║██║██║     ██╔══██╗\n" 
          printf "   ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗    ██████╔╝█████╗  ██████╔╝██║   ██║██║██║     ██║  ██║\n" 
          printf "   ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║    ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██║██║     ██║  ██║\n" 
          printf "   ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║    ██║  ██║███████╗██████╔╝╚██████╔╝██║███████╗██████╔╝\n" 
          printf "   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝  ╚═╝╚══════╝╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝ \n" 
          printf "                                                                                                 \n"
          if [ ! -d "$flake_dir" ] || [ ! -f "$flake_dir/flake.nix" ]; then
            stderr "Flake directory: '$flake_dir' is not valid"
            exit 1
          fi
          # Execute the commands
          cmd_build="nom build $flake_dir#nixosConfigurations.${profile}.config.system.build.toplevel --out-link /tmp/nixos-configuration --accept-flake-config && fish"
          cmd_nvd="nvd diff /run/current-system /tmp/nixos-configuration"
          su - ${g.username} -c "$cmd_build && $cmd_nvd" && /tmp/nixos-configuration/bin/switch-to-configuration switch || exit 1
        '';
    };
  };
}
