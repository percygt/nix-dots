{
  config,
  lib,
  libx,
  ...
}:
{
  options.modules.core.zram = {
    enable = libx.enableDefault "zram";
  };

  config = lib.mkIf config.modules.core.zram.enable {
    # Balance lz4 latency/throughput
    boot.kernel.sysctl."vm.page-cluster" = 1;

    # Hibernate and hybrid-sleep won't work correctly without
    # an on-disk swap.
    systemd.targets.hibernate.enable = lib.mkForce false;
    systemd.targets.hybrid-sleep.enable = lib.mkForce false;

    # Enable zramSwap
    zramSwap = {
      algorithm = "lz4";
      memoryPercent = 100;
      enable = true;
    };
  };
}
