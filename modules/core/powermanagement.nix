{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.core.powermanagement;
  p = pkgs.writeScriptBin "charge-upto" ''
    echo ''${0:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
  '';
in
{
  config = lib.mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = true;
      # battery info
      upower = {
        enable = true;
        percentageLow = 20;
        allowRiskyCriticalPowerAction = true;
        criticalPowerAction = "Suspend";
      };
      thermald.enable = true;
      system76-scheduler = {
        enable = true;
        useStockConfig = false; # our needs are modest
        settings = {
          # CFS profiles are switched between "default" and "responsive"
          # according to power source ("default" on battery, "responsive" on
          # wall power).  defaults are fine, except maybe this:
          cfsProfiles.default.preempt = "voluntary";
          # "voluntary" supposedly conserves battery but may also allow some
          # audio skips, so consider changing to "full"
          processScheduler = {
            # Pipewire client priority boosting is not needed when all else is
            # configured properly, not to mention all the implied
            # second-guessing-the-kernel and priority inversions, so:
            pipewireBoost.enable = false;
            # I believe this exists solely for the placebo effect, so disable:
            foregroundBoost.enable = false;
          };
        };
        assignments = {
          # confine builders / compilers / LSP servers etc. to the "batch"
          # scheduling class automagically.  add matchers to taste!
          batch = {
            class = "batch";
            matchers = [
              "bazel"
              "clangd"
              "rust-analyzer"
            ];
          };
        };
        # do not disturb adults:
        exceptions = [
          "include descends=\"schedtool\""
          "include descends=\"nice\""
          "include descends=\"chrt\""
          "include descends=\"taskset\""
          "include descends=\"ionice\""

          "schedtool"
          "nice"
          "chrt"
          "ionice"

          "dbus"
          "dbus-broker"
          "rtkit-daemon"
          "taskset"
          "systemd"
        ];
      };
      # ananicy = {
      #   enable = true;
      #   package = pkgs.ananicy-cpp;
      #   rulesProvider = pkgs.ananicy-rules-cachyos;
      # };
    };
    powerManagement = {
      powerDownCommands = ''
        # Lock all sessions
        loginctl lock-sessions

        # Wait for lockscreen(s) to be up
        sleep 1
      '';
    };
    environment.systemPackages = lib.mkIf cfg.enableChargeUptoScript [
      p
    ];
    systemd.services.battery-charge-threshold = {
      wantedBy = [
        "local-fs.target"
        "suspend.target"
      ];
      after = [
        "local-fs.target"
        "suspend.target"
      ];
      description = "Set the battery charge threshold to ${toString cfg.chargeUpto}%";
      startLimitBurst = 5;
      startLimitIntervalSec = 1;
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = "${pkgs.runtimeShell} -c 'echo ${toString cfg.chargeUpto} > /sys/class/power_supply/BAT?/charge_control_end_threshold'";
      };
    };
  };
}
