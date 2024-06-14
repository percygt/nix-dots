{
  config,
  lib,
  pkgs,
  libx,
  ...
}: {
  options = {
    core.packages = {
      enable =
        lib.mkEnableOption "Enable core packages";
    };
  };

  config = lib.mkIf config.core.packages.enable {
    environment.systemPackages = with pkgs;
      [
        foot
      ]
      ++ (libx.corePackages pkgs);
  };
}
