{
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernel = {
      sysctl = {
        "fs.file-max" = 2097152;
        "fs.inotify.max_user_watches" = 524288;
        "net.core.netdev_max_backlog" = 16384;
        "net.core.somaxconn" = 8192;
        "net.ipv4.tcp_slow_start_after_idle" = 0;
      };
    };
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        editor = false;
      };
    };
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "loglevel=0"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "boot.shell_on_fail"
      "udev.log_priority=3"
    ];
  };
}
