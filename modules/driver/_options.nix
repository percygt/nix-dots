{ lib, ... }:
{
  options.modules.drivers = {
    adb.enable = lib.mkEnableOption "Enable adb";
    bluetooth.enable = lib.mkEnableOption "Enable bluetooth";
    printer.enable = lib.mkEnableOption "Enable printers";
  };
}
