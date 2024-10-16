{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.drivers = {
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
  };

  config = lib.mkIf config.modules.drivers.intel.enable {
    boot = {
      initrd.kernelModules = [ config.modules.drivers.intel.gpu.driver ];
      kernelParams =
        if (config.modules.drivers.intel.gpu.driver == "xe") then
          [
            "i915.force_probe=!9a49"
            "xe.force_probe=9a49"
          ]
        else if (config.modules.drivers.intel.gpu.driver == "i915") then
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
    hardware.graphics.extraPackages = with pkgs; [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          vaapiIntel
        else
          intel-vaapi-driver.override { enableHybridCodec = true; }
      )
      intel-media-driver
    ];

    hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          vaapiIntel
        else
          intel-vaapi-driver.override { enableHybridCodec = true; }
      )
      intel-media-driver
    ];
  };
}
