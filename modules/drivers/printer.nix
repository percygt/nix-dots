{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  options.modules.drivers.printer.enable = lib.mkEnableOption "Enable printers";
  config = lib.mkIf config.modules.drivers.printer.enable {
    services.printing = {
      enable = true;
      drivers = [ pkgs.epson-201401w ];
    };
    hardware.sane.enable = true; # enables support for SANE scanners
    hardware.sane.extraBackends = [
      pkgs.epkowa
      pkgs.utsushi
    ];
    services.udev.packages = [ pkgs.utsushi ];
    users.users.${username}.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}
