{
  config,
  lib,
  pkgs,
  libx,
  ...
}:
{
  options.modules.core.boot = {
    enable = libx.enableDefault "boot";
  };

  config = lib.mkIf config.modules.core.boot.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      tmp.cleanOnBoot = true;
      kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

      consoleLogLevel = 0;

      loader = {
        timeout = 0;
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          configurationLimit = 20;
          consoleMode = "max";
          editor = false;
        };
      };

      plymouth.enable = true;
      plymouth.theme = "breeze";

      kernelParams = [
        "quiet"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "boot.shell_on_fail"
      ];
    };
  };
}
