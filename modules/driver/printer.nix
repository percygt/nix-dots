{
  config,
  lib,
  pkgs,
  username,
  pkgs-stable,
  ...
}:
{
  config = lib.mkIf config.modules.driver.printer.enable {
    # hardware.printers.ensurePrinters = [ g.localPrinter ];
    environment.systemPackages = [ pkgs.epsonscan2 ];
    programs.system-config-printer.enable = true;
    services = {
      udev.packages = [ pkgs.utsushi ];
      system-config-printer.enable = true;
      printing = {
        drivers = [ pkgs-stable.epson-2014-w ];
        enable = true;
      };
    };
    hardware = {
      sane = {
        enable = true;
        extraBackends = [
          pkgs.epkowa
          pkgs.utsushi
        ];
      };
    };
    users.users.${username}.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}
