{
  pkgs,
  lib,
  flakeDirectory,
  username,
  ...
}: {
  home-manager.users.${username} = {pkgs, ...}: {
    systemd.user.services = {
      nixos-rebuild = {
        Service = {
          Type = "exec";
          ExecStart = lib.getExe (pkgs.writeShellApplication {
            name = "nixos-rebuild-exec-start";
            runtimeInputs = [pkgs.coreutils-full pkgs.nixos-rebuild pkgs.systemd pkgs.mpv];
            text = ''
              notify_success() {
                notify-send "NixOS rebuild successful"
                { mpv ${pkgs.success-alert} || true; } &
                sleep 5 && kill -9 "$!"
              }
              notify_failure() {
                notify-send --urgency=critical "NixOS rebuild failed"
                { mpv ${pkgs.failure-alert} || true; } &
                sleep 5 && kill -9 "$!"
              }
              if systemctl start nixos-rebuild.service; then
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
          });
        };
      };
    };
  };
  security.polkit = {
    debug = true;
    extraConfig =
      /*
      javascript
      */
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
    extraConfig = ''
      [Manager]
      DefaultTimeoutStopSec=10
      DefaultTimeoutAbortSec=10
    '';
    services = {
      nixos-rebuild = {
        restartIfChanged = false;
        serviceConfig = {
          Type = "exec";
          ExecStart = lib.getExe (pkgs.writeShellApplication {
            name = "nixos-rebuild";
            runtimeInputs = [pkgs.coreutils pkgs.iputils pkgs.nixos-rebuild pkgs.git];
            text = ''
              flake_dir="${flakeDirectory}"
              flags=("--accept-flake-config" "--option" "eval-cache" "false")
              stderr() { printf "%s\n" "$*" >&2; }
              printf "╔════════════════════════════════════════════════════╗\n"
              printf "║                                                    ║\n"
              printf "║  ░█▄░█░█░▀▄▀░▄▀▄░▄▀▀░▒░▒█▀▄▒██▀░██▄░█▒█░█░█▒░░█▀▄  ║\n"
              printf "║  ░█▒▀█░█░█▒█░▀▄▀▒▄██░▀▀░█▀▄░█▄▄▒█▄█░▀▄█░█▒█▄▄▒█▄▀  ║\n"
              printf "║                                                    ║\n"
              printf "╚════════════════════════════════════════════════════╝\n"
              if [ ! -d "$flake_dir" ] || [ ! -f "$flake_dir/flake.nix" ]; then
                stderr "Flake directory: '$flake_dir' is not valid"
                exit 1
              fi

              if ping -c 1 -W 2 1.1.1.1 &>/dev/null; then
                printf "Network is up, substituters engaged 🌎"
              else
                printf "Network is down, off-grid mode activated 🚫"
              fi

              if ! nixos-rebuild "''${flags[@]}" switch --flake "$flake_dir#"; then
                stderr "Something went wrong 🤔❌"
                exit 1
              fi
              printf "New NixOS generation created 🥳🌲"
            '';
          });
        };
      };
    };
  };
}
