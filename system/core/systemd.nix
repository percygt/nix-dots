{
  config,
  lib,
  ...
}: {
  options = {
    core.systemd = {
      enable =
        lib.mkEnableOption "Enable systemd services";
      initrd.enable = lib.mkEnableOption "Enable systemd initrd";
    };
  };

  config = lib.mkIf config.core.systemd.enable {
    services.journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };
    boot.initrd = lib.mkIf config.core.systemd.initrd.enable {
      systemd.enable = true;
    };
  };
}
