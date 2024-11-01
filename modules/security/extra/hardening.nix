{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.security.common.hardening.enable = lib.mkOption {
    description = "Enable hardening";
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf config.modules.security.common.hardening.enable {
    security = {
      protectKernelImage = false;
      tpm2 = {
        enable = true;
        pkcs11.enable = true;
        tctiEnvironment.enable = true;
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };

    systemd.coredump.enable = false;
    services.opensnitch.enable = true;

    environment.systemPackages = [ pkgs.opensnitch-ui ];
  };
}
