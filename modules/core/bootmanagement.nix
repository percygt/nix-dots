{
  config,
  lib,
  pkgs,
  ...
}: {
  options.core.bootmanagement = {
    enable = lib.mkOption {
      description = "Enable bootmanagement";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.core.bootmanagement.enable {
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
          configurationLimit = 5;
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
