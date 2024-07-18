{
  config,
  lib,
  pkgs,
  configx,
  ...
}:
{
  options.core.packages = {
    enable = lib.mkOption {
      description = "Enable core packages";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.core.packages.enable {
    environment.systemPackages = configx.corePackages pkgs;
  };
}
