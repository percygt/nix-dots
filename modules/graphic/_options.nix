{ lib, config, ... }:
{
  options.modules.graphics = {
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
      prime = {
        enable = lib.mkEnableOption "Enable nvidia-prime";
        intelBusId = lib.mkOption {
          description = "Intel Bus ID";
          default = "PCI:0:2:0";
          type = lib.types.str;
        };
        nvidiaBusId = lib.mkOption {
          description = "Disable nvidia gpu";
          default = "PCI:2:0:0";
          type = lib.types.str;
        };
        batterySaverSpecialisation = lib.mkEnableOption "Enable battery saver specialisation";
      };
      bye = lib.mkOption {
        description = "Disable nvidia gpu";
        default = !config.modules.graphics.nvidia.prime.enable;
        type = lib.types.bool;
      };
    };
  };
}
