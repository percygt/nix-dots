{
  lib,
  pkgs,
  ...
}:
{
  options.modules.desktop.niri = {
    package = lib.mkOption {
      description = "Niri package";
      type = lib.types.package;
      default = pkgs.niri-unstable-git;
    };
  };
}
