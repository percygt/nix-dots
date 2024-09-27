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
        "splash"
        "loglevel=3"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "systemd.show_status=false"
        "rd.systemd.show_status=false"
        "boot.shell_on_fail"
        "udev.log_priority=3"
      ];
    };
  };
}
