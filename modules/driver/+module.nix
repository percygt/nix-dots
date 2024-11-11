{ lib, ... }:
{
  options.modules.driver = {
    adb.enable = lib.mkEnableOption "Enable adb";

    bluetooth.enable = lib.mkEnableOption "Enable bluetooth";

    printer.enable = lib.mkEnableOption "Enable printers";

    intel = {
      enable = lib.mkEnableOption "Enable intel graphics";
      gpu.driver = lib.mkOption {
        description = "Intel graphics driver to use";
        type = lib.types.enum [
          "i915"
          "xe"
        ];
        default = "i915";
      };
    };

    nvidia = {
      prime.enable = lib.mkEnableOption "Enable nvidia-prime";
      bye = lib.mkOption {
        description = "Disable nvidia gpu";
        default = false;
        type = lib.types.bool;
      };
    };
  };
}
