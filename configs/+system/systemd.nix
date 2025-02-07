{
  services = {
    # Use power button to sleep instead of poweroff
    logind.powerKey = "suspend";
    logind.powerKeyLongPress = "poweroff";

    journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };

    udev = {
      extraRules = ''
        # https://wiki.archlinux.org/title/Improving_performance#Changing_I/O_scheduler
        # HDD
        ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

        # SSD
        ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"

        # NVMe SSD
        ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

        # Realtime Audio (https://gentoostudio.org/?page_id=420)
        #KERNEL=="rtc0", GROUP="audio"
        #KERNEL=="hpet", GROUP="audio"
      '';
    };
  };
  systemd.extraConfig = ''
    [Manager]
    DefaultTimeoutStopSec=10
    DefaultTimeoutAbortSec=10
  '';
}
