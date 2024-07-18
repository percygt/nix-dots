{
  pkgs,
  configx,
  lib,
  config,
  ...
}:
{
  options = {
    generic.packages = {
      enable = lib.mkEnableOption "Enable overlays";
    };
  };

  config = lib.mkIf config.generic.packages.enable { home.packages = configx.corePackages pkgs; };
}
