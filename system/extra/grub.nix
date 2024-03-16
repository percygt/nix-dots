{config, ...}: {
  # Bootloader.
  boot = {
    # use latest kernel
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];
}
