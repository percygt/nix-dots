{ lib, ... }:
{
  options.modules.security = {
    fprintd.enable = lib.mkEnableOption "Enable fprintd";
    blocky.enable = lib.mkEnableOption "Enable blocky";
    hardening.enable = lib.mkEnableOption "Enable hardening";
    kernel.enable = lib.mkEnableOption "Enable kernel";
    extraPackages.enable = lib.mkEnableOption "Enable extraPackages";
  };
}
