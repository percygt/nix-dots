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
    # tmp.cleanOnBoot = true;
    # kernel.sysctl = {
    #   "net.ipv4.ip_forward" = 1;
    #   "net.ipv6.conf.all.forwarding" = 1;
    # };

    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        editor = false;
      };
    };
    plymouth = {
      enable = true;
      theme = "pixels";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "pixels" ];
        })
      ];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "loglevel=0"
      # "nmi_watchdog=0"
      # "nowatchdog"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "boot.shell_on_fail"
      "udev.log_priority=3"
    ];
  };
}
