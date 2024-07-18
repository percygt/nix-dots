{ config, lib, ... }:
{
  options = {
    core.systemd = {
      enable = lib.mkOption {
        description = "Enable systemd services";
        default = true;
        type = lib.types.bool;
      };
      initrd.enable = lib.mkOption {
        description = "Enable systemd initrd";
        default = true;
        type = lib.types.bool;
      };
      initrd.rootDevice = lib.mkOption {
        description = "Required root device in initrd before executing wipeScript";
        default = "dev-root_vg-root.device";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.core.systemd.enable {
    services.journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };
    systemd.extraConfig = "DefaultTimeoutStopSec=10s";
    boot.initrd = lib.mkIf config.core.systemd.initrd.enable {
      services.lvm.enable = true;
      systemd = {
        enable = true;
        emergencyAccess = true;
      };
    };
  };
}
