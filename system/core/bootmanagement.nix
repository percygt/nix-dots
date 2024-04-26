{
  config,
  lib,
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
          editor = false;
        };
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
