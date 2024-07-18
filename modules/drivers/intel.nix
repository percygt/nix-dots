{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    drivers.intel = {
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

  config = lib.mkIf config.drivers.intel.enable {
    boot.initrd.kernelModules = [ config.drivers.intel.gpu.driver ];
    boot.kernelParams =
      if (config.drivers.intel.gpu.driver == "xe") then
        [
          "i915.force_probe=!9a49"
          "xe.force_probe=9a49"
        ]
      else if (config.hardware.intelgpu.driver == "i915") then
        [ "i915.enable_guc=3" ]
      else
        [ ];

    environment.systemPackages = with pkgs; [ glxinfo ];
    environment.variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (lib.mkDefault "va_gl");
      LIBVA_DRIVER_NAME = "iHD";
    };

    hardware.graphics.extraPackages = with pkgs; [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          vaapiIntel
        else
          intel-vaapi-driver
      )
      intel-media-driver
    ];

    hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          vaapiIntel
        else
          intel-vaapi-driver
      )
      intel-media-driver
    ];
  };
}
