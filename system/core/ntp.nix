{
  config,
  lib,
  ...
}: {
  options = {
    core.ntp = {
      enable =
        lib.mkEnableOption "Enable ntp services";
    };
  };

  config = lib.mkIf config.core.ntp.enable {
    services.chrony.enable = true;
    networking.timeServers = [
      "time.upd.edu.ph"
      "time.cloudflare.com"
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
  };
}
