{
  pkgs,
  config,
  lib,
  isGeneric,
  ...
}:
{
  config = lib.mkIf isGeneric {
    fonts.fontconfig.enable = true;
    home.packages = import ./allFonts.nix { inherit pkgs config; };
    nixpkgs.config.joypixels.acceptLicense = true;
  };
}
