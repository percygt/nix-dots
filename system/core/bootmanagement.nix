{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    core.bootmanagement = {
      enable =
        lib.mkEnableOption "Enable bootmanagement";
    };
  };

  config = lib.mkIf config.core.bootmanagement.enable {
    boot = {
      kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

      consoleLogLevel = 0;

      loader = {
        systemd-boot.enable = true;
        systemd-boot.consoleMode = "auto";
        # efi.efiSysMountPoint = "/boot/efi";
        efi.canTouchEfiVariables = true;
      };

      plymouth = {
        enable = true;
        # theme = "spinner-monochrome";
        # themePackages = [
        #   (pkgs.plymouth-spinner-monochrome.override {
        #     inherit (config.boot.plymouth) logo;
        #   })
        # ];
      };
      # loader.timeout = 0;
      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];
      initrd.verbose = false;
    };
  };
}
