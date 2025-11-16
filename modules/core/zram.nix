{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.core.zram.enable {

    # Hibernate and hybrid-sleep won't work correctly without
    # an on-disk swap.
    systemd.targets.hibernate.enable = lib.mkForce false;
    systemd.targets.hybrid-sleep.enable = lib.mkForce false;

    # ZRAM swap
    zramSwap.enable = true;
    # use values deemed by folk wisdom to be optimal with zstd zram swap
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.watermark_boost_factor" = 0;
    };
  };
}
