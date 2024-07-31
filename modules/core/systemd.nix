{ config, lib, ... }:
{
  options.modules.core.systemd = {
    enable = lib.mkOption {
      description = "Enable systemd services";
      default = true;
      type = lib.types.bool;
    };
    initrd = {
      enable = lib.mkOption {
        description = "Enable systemd initrd";
        default = true;
        type = lib.types.bool;
      };
      rootDeviceName = lib.mkOption {
        description = "Declare root device before executing wipeScript e.g. /dev/root_vg/root -> ['dev' 'root_vg' 'root']";
        default = [
          "dev"
          "root_vg"
          "root"
        ];
        type = lib.types.lists;
      };
      rootDevice = lib.mkOption {
        description = "Root device in initrd before executing wipeScript e.g. /dev/root_vg/root -> dev-root_vg-root.device";
        default = "dev-root_vg-root.device";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.modules.core.systemd.enable {
    services.journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };
    systemd.extraConfig = ''
      [Manager]
      DefaultTimeoutStopSec=10
      DefaultTimeoutAbortSec=10
    '';
    boot.initrd = lib.mkIf config.modules.core.systemd.initrd.enable {
      services.lvm.enable = true;
      systemd = {
        enable = true;
        emergencyAccess = true;
      };
    };
  };
}
