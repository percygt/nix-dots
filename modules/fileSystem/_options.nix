{ lib, config, ... }:
{
  options.modules.fileSystem = {
    btrfsAutoscrub.enable = lib.mkEnableOption "Enable btrfs autoscrub";
    udisks.enable = lib.mkEnableOption "Enable udisk2";

    ## ephemeral
    ephemeral = {
      enable = lib.mkEnableOption "Enable ephemeral";

      phase1Systemd = {
        enable = lib.mkOption {
          description = "Enable phase1 systemd";
          default = config.modules.fileSystem.ephemeral.enable;
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
        cfg = config.modules.fileSystem.persist;
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
          default = config.modules.fileSystem.ephemeral.enable;
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
  };

}
