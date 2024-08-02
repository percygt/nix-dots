{
  config,
  lib,
  libx,
  ...
}:
let
  cfg = config.modules.core.systemd;
in
{
  options.modules.core.systemd = {
    enable = libx.enableDefault "systemd";
    initrd = {
      enable = lib.mkOption {
        description = "Enable systemd initrd";
        default = cfg.enable;
        type = lib.types.bool;
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
