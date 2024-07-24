{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ ./module.nix ];
  fonts.fontconfig.enable = true;
  home.packages = import ./allFonts.nix { inherit pkgs config; };
  nixpkgs.config = {
    # Disable if you don't want unfree packages
    allowUnfree = lib.mkForce true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: lib.mkForce true;
    joypixels.acceptLicense = true;
  };
}
