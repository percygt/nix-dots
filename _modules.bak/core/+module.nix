{ lib, config, ... }:
{
  options.modules.core = {
    ## wpasupplicant
    wpasupplicant.enable = lib.mkEnableOption "Enable wpa";

    ## ephemeral
    ephemeral = {
      enable = lib.mkEnableOption "Enable ephemeral";

      phase1Systemd = {
        enable = lib.mkOption {
          description = "Enable phase1 systemd";
          default = config.modules.core.ephemeral.enable;
          type = lib.types.bool;
        };
      };
      rootDeviceName = lib.mkOption {
        description = "Declare root device name e.g. /dev/root_vg/root -> ['dev' 'root_vg' 'root']";
        default = [
          "dev"
          "root_vg"
          "root"
        ];
        type = with lib.types; listOf str;
      };
    };

    ## persist
    persist =
      let
        cfg = config.modules.core.persist;
        options = param: {
          directories = lib.mkOption {
            type =
              with lib.types;
              listOf (oneOf [
                attrs
                str
              ]);
            default = [ ];
            description = "Directories to pass to environment.persistence attribute for ${param} under ${cfg.prefix}";
          };
          files = lib.mkOption {
            type =
              with lib.types;
              listOf (oneOf [
                attrs
                str
              ]);
            default = [ ];
            description = "Files to pass to environment.persistence attribute for ${param} under ${cfg.prefix}";
          };
        };
      in
      {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.modules.core.ephemeral.enable;
          description = "Enable persistence settings";
        };
        prefix = lib.mkOption {
          type = lib.types.str;
          default = "/persist";
          description = "The path to where persistent local storage happens";
        };
        systemPrefix = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.prefix}/system";
          description = "The path to where persistent local storage happens";
        };
        systemData = options "systemData";
        userData = options "userData";
      };

    ## battery
    powermanagement = {
      enable = lib.mkEnableOption "Enable powermanagement services";
      chargeUpto = lib.mkOption {
        description = "Maximum level of charge for your battery, as a percentage.";
        default = 80;
        type = lib.types.int;
      };
      enableChargeUptoScript = lib.mkOption {
        description = "Whether to add charge-upto to environment.systemPackages. `charge-upto 75` temporarily sets the charge limit to 75%.";
        type = lib.types.bool;
        default = config.modules.core.powermanagement.enable;
      };
    };

    ## autoupgrade
    autoupgrade = {
      enable = lib.mkEnableOption "Enable autoupgrade";

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
        default = "Sun,Tue,Wed,Thu,Sat *-*-* 6:30:00";
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

}
