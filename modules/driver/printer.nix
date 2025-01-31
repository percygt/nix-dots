{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  config = lib.mkIf config.modules.driver.printer.enable {
    # hardware.printers.ensurePrinters = [ g.localPrinter ];
    environment.systemPackages = [ pkgs.old.epsonscan2 ];
    programs.system-config-printer.enable = true;
    services = {
      udev.packages = [ pkgs.utsushi ];
      system-config-printer.enable = true;
      printing = {
        enable = true;
        drivers = [ pkgs.stable.epson-201401w ];
      };
    };
    hardware = {
      sane = {
        enable = true;
        extraBackends = [
          pkgs.old.epsonscan2
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
