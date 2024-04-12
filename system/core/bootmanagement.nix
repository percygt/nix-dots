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
      initrd.systemd.enable = true;

      kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

      loader = {
        systemd-boot.enable = true;
        systemd-boot.consoleMode = "auto";
        # efi.efiSysMountPoint = "/boot/efi";
        efi.canTouchEfiVariables = true;
      };

      # Enable Plymouth and surpress some logs by default.
      plymouth = {
        enable = true;
        themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
        theme = "catppuccin-mocha";
      };

      kernelParams = [
        # The 'splash' arg is included by the plymouth option
        "quiet"
        "loglevel=3"
        "rd.udev.log_priority=3"
        "vt.global_cursor_default=0"
      ];
    };
  };
}
