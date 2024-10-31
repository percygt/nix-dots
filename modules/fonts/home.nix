{
  pkgs,
  config,
  lib,
  isGeneric,
  ...
}:
{
  imports = [ ./module.nix ];
  config = lib.mkIf isGeneric {
    fonts.fontconfig.enable = true;
    home.packages = import ./allFonts.nix { inherit pkgs config; };
    nixpkgs.config.joypixels.acceptLicense = true;
  };
}
