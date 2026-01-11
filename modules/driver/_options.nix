{ lib, ... }:
{
  options.modules.drivers = {
    bluetooth.enable = lib.mkEnableOption "Enable bluetooth";
    printer.enable = lib.mkEnableOption "Enable printers";
  };
}
