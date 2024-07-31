# Run automatic updates. Replaces system.autoUpgrade.
{
  config,
  lib,
  pkgs,
  username,
  flakeDirectory,
  homeDirectory,
  ...
}:

let
  cfg = config.modules.core.autoupgrade;

  # List of packages to include in each service's $PATH
  pathPkgs =
    (with pkgs; [
      coreutils
      git
      gnutar
      gzip
      nh
      sudo
      xz.bin
      nixos-rebuild
    ])
    ++ [
      config.programs.ssh.package
      config.nix.package.out
    ];
in
{
  options.modules.core = {
    autoupgrade = {
      enable = lib.mkOption {
        description = "Enables automatic system updates.";
        type = lib.types.bool;
        default = true;
      };
      branches = lib.mkOption {
        type = lib.types.attrs;
        description = "Which local and remote branches to compare.";
        default = {
          local = "main";
          remote = "main";
          remoteName = "origin";
        };
      };
      onCalendar = lib.mkOption {
        default = "daily";
        type = lib.types.str;
        description = "How frequently to run updates. See systemd.timer(5) and systemd.time(7) for configuration details.";
      };
      persistent = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "If true, the time when the service unit was last triggered is stored on disk. When the timer is activated, the service unit is triggered immediately if it would have been triggered at least once during the time when the timer was inactive. This is useful to catch up on missed runs of the service when the system was powered down.";
      };
      pushUpdates = lib.mkOption {
        description = "Updates the flake.lock file and pushes it back to the repo.";
        type = lib.types.bool;
        default = true;
      };
    };
  };

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
          User = "root";
        };
        path = pathPkgs;
        # Git diffing strategy courtesy of https://stackoverflow.com/a/40255467
        script = ''
          cd ${flakeDirectory}
          # Check if there are changes from Git.
          echo "Pulling latest version..."
          sudo -u ${username} git fetch
          sudo -u ${username} git diff --quiet --exit-code ${cfg.branches.local} ${cfg.branches.remoteName}/${cfg.branches.remote} || true
          # If we have changes (git diff returns 1), pull changes and run the update
          if [ $? -eq 1 ]; then
            echo "Updates found, running nixos-rebuild..."
            sudo -u ${username} git pull
            nixos-rebuild switch --flake .
          else
            echo "No updates found. Exiting."
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
      home-manager.users.${username} =
        { pkgs, ... }:
        {
          systemd.user.services = {
            nixos-upgrade = {
              Service = {
                Type = "exec";
                ExecStart = lib.getExe (
                  pkgs.writeShellApplication {
                    name = "nixos-upgrade-exec-start";
                    runtimeInputs = [
                      pkgs.coreutils-full
                      pkgs.nixos-rebuild
                      pkgs.systemd
                      pkgs.mpv
                      pkgs.libnotify
                    ];
                    text = ''
                      notify_success() {
                        notify-send -i emblem-default "System Autoupgrade" "NixOS autoupgrade successful"
                        { mpv ${pkgs.success-alert} || true; } &
                        sleep 5 && kill -9 "$!"
                      }
                      notify_failure() {
                        notify-send --urgency=critical -i emblem-error "System Autoupgrade" "NixOS autoupgrade failed!"
                        { mpv ${pkgs.failure-alert} || true; } &
                        sleep 5 && kill -9 "$!"
                      }
                      if systemctl start nixos-upgrade.service; then
                        notify-send -i zen-icon "System Autoupgrade" "NixOS autoupgrade started"
                        while systemctl -q is-active nixos-upgrade.service; do
                          sleep 1
                        done
                        if systemctl -q is-failed nixos-upgrade.service; then
                          notify_failure
                        else
                          notify_success
                        fi
                      else
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
      };
  };
}
