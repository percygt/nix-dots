{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.graphics.intel;
in
{

  config = lib.mkIf cfg.enable {
    boot = {
      initrd.kernelModules = [ cfg.gpu.driver ];
      kernelParams =
        if (cfg.gpu.driver == "xe") then
          [
            "i915.force_probe=!9a49"
            "xe.force_probe=9a49"
          ]
        else if (cfg.gpu.driver == "i915") then
          [ "i915.enable_guc=3" ]
        else
          [ ];
    };
    services.xserver.videoDrivers = lib.mkDefault [ "intel" ];
    environment.systemPackages = with pkgs; [
      glxinfo
      intel-gpu-tools
      libva-utils
    ];
    environment.variables = {
      LIBVA_DRIVER_NAME = lib.mkIf (cfg.gpu.driver == "xe") "iHD";
    };
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        ((pkgs.intel-vaapi-driver or pkgs.vaapiIntel).override {
          enableHybridCodec = true;
        })
        pkgs.intel-media-driver
        pkgs.intel-ocl
        pkgs.intel-compute-runtime
        pkgs.vpl-gpu-rt
      ];

      extraPackages32 = [
        ((pkgs.driversi686Linux.intel-vaapi-driver or pkgs.driversi686Linux.vaapiIntel).override {
          enableHybridCodec = true;
        })
        pkgs.driversi686Linux.intel-media-driver
      ];
    };
  };
}
