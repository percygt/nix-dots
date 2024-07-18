{
  lib,
  config,
  outputs,
  ...
}:
{
  options = {
    generic.overlays = {
      enable = lib.mkEnableOption "Enable overlays";
    };
  };

  config = lib.mkIf config.generic.overlays.enable {
    nixpkgs.overlays = builtins.attrValues outputs.overlays;
  };
}
