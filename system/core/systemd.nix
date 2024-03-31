{
  config,
  lib,
  ...
}: {
  options = {
    core.systemd = {
      enable =
        lib.mkEnableOption "Enable systemd services";
    };
  };

  config = lib.mkIf config.core.systemd.enable {
    services.journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };
  };
}
