{
  pkgs,
  lib,
  config,
  ...
}: let
  kmk0 = "${config.home.homeDirectory}/data/keeps/m0.kdbx";
in {
  options = {
    security.keepass.enable =
      lib.mkEnableOption "Enable keepass";
  };

  config = lib.mkIf config.security.keepass.enable {
    home.packages = with pkgs; [
      keepassxc
    ];
    home.sessionVariables.KPDB = kmk0;
  };
}
