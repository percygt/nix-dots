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
        theme = "catppuccin-macchiato";
        themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "macchiato"; }) ];
      };

      consoleLogLevel = 0;
      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "boot.shell_on_fail"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };
  };
}
