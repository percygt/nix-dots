{
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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
      "splash"
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
