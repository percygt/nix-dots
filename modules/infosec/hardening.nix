{
  pkgs,
  lib,
  config,
  ...
}: {
  options.infosec = {
    hardening = {
      enable = lib.mkEnableOption "Enable hardening";
    };
  };
  # configured in home
  config = lib.mkIf config.infosec.hardening.enable {
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

    environment.systemPackages = [
      pkgs.opensnitch-ui
    ];
  };
}
