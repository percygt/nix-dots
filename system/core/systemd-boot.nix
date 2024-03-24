{
  config,
  lib,
  ...
}: {
  options = {
    core.systemd-boot = {
      enable =
        lib.mkEnableOption "Enable systemd-boot";
    };
  };

  config = lib.mkIf config.core.systemd-boot.enable {
    boot = {
      initrd.systemd.enable = true;

      kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

      loader = {
        systemd-boot.enable = true;
        systemd-boot.consoleMode = "auto";
        efi.efiSysMountPoint = "/boot/efi";
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
