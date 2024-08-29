{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.drivers = {
    intel = {
      enable = lib.mkEnableOption "Enable intel gpu";
      gpu.driver = lib.mkOption {
        description = "Intel GPU driver to use";
        type = lib.types.enum [
          "i915"
          "xe"
        ];
        default = "i915";
      };
    };
  };

  config = lib.mkIf config.modules.drivers.intel.enable {
    boot = {
      initrd.kernelModules = [ config.modules.drivers.intel.gpu.driver ];
      extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
      kernelParams =
        if (config.modules.drivers.intel.gpu.driver == "xe") then
          [
            "acpi_call"
            "i915.force_probe=!9a49"
            "xe.force_probe=9a49"
          ]
        else if (config.hardware.intelgpu.driver == "i915") then
          [ "i915.enable_guc=3" ]
        else
          [ ];
    };
    services.xserver.videoDrivers = lib.mkDefault [ "intel" ];
    environment.systemPackages = with pkgs; [
      glxinfo
      intel-gpu-tools
    ];
    environment.variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (lib.mkDefault "va_gl");
      LIBVA_DRIVER_NAME = "iHD";
    };

    hardware.graphics.extraPackages = [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          pkgs.vaapiIntel
        else
          pkgs.intel-vaapi-driver
      )
      pkgs.intel-media-driver
    ];

    hardware.graphics.extraPackages32 = [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          pkgs.driversi686Linux.vaapiIntel
        else
          pkgs.driversi686Linux.intel-vaapi-driver
      )
      pkgs.driversi686Linux.intel-media-driver
    ];
  };
}
