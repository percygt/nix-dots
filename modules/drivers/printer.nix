{
  config,
  lib,
  pkgs,
  ...
}:
let
  g = config._general;
in
{
  options.modules.drivers.printer.enable = lib.mkEnableOption "Enable printers";
  config = lib.mkIf config.modules.drivers.printer.enable {
    # hardware.printers.ensurePrinters = [ g.localPrinter ];
    environment.systemPackages = [ pkgs.epsonscan2 ];
    programs.system-config-printer.enable = true;
    services = {
      udev.packages = [ pkgs.utsushi ];
      system-config-printer.enable = true;
      printing = {
        enable = true;
        drivers = [ pkgs.epson-201401w ];
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
    users.users.${g.username}.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}
