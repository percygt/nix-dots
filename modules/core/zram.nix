{ config, lib, ... }:
{
  options.core.zram = {
    enable = lib.mkOption {
      description = "Enable zram";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.core.zram.enable {
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
