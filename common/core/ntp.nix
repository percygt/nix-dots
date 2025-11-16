{
  persistSystem.directories = [ "/var/lib/chrony" ];
  services.chrony.enable = true;
  networking.timeServers = [
    "time.upd.edu.ph"
    "time.cloudflare.com"
    "0.nixos.pool.ntp.org"
    "1.nixos.pool.ntp.org"
    "2.nixos.pool.ntp.org"
    "3.nixos.pool.ntp.org"
  ];
}
