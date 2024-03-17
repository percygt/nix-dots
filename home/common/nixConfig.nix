{
  lib,
  is_generic_linux,
  ...
}:
lib.mkIf is_generic_linux {
  nixpkgs.config = {
    # Disable if you don't want unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
}
