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
      kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

      consoleLogLevel = 0;

      initrd.verbose = false;

      supportedFilesystems = ["btrfs"];

      loader = {
        systemd-boot.enable = true;
        systemd-boot.consoleMode = "auto";
        # efi.efiSysMountPoint = "/boot/efi";
        efi.canTouchEfiVariables = true;
      };

      # Enable Plymouth and surpress some logs by default.
      plymouth.enable = true;

      kernelParams = [
        # The 'splash' arg is included by the plymouth option
        "quiet"
        "loglevel=3"
        "rd.udev.log_priority=3"
        "vt.global_cursor_default=0"
        "boot.shell_on_fail"
      ];
    };
  };
}
