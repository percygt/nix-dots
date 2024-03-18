{
  lib,
  is_generic_linux,
  pkgs,
  ui,
  ...
}:
lib.mkIf is_generic_linux {
  fonts.fontconfig.enable = true;
  home.packages = ui.fonts.packages pkgs;
  nixpkgs.config = {
    # Disable if you don't want unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
    joypixels.acceptLicense = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
}
