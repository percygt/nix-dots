{
  config,
  lib,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.modules.driver.intel.enable {
    boot = {
      initrd.kernelModules = [ config.modules.driver.intel.gpu.driver ];
      kernelParams =
        if (config.modules.driver.intel.gpu.driver == "xe") then
          [
            "i915.force_probe=!9a49"
            "xe.force_probe=9a49"
          ]
        else if (config.modules.driver.intel.gpu.driver == "i915") then
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
      ((pkgs.intel-vaapi-driver or pkgs.vaapiIntel).override {
        enableHybridCodec = true;
      })
      pkgs.intel-media-driver
      pkgs.intel-ocl
      pkgs.intel-compute-runtime
      pkgs.vpl-gpu-rt
    ];

    hardware.graphics.extraPackages32 = [
      ((pkgs.driversi686Linux.intel-vaapi-driver or pkgs.driversi686Linux.vaapiIntel).override {
        enableHybridCodec = true;
      })
      pkgs.driversi686Linux.intel-media-driver
    ];
  };
}
