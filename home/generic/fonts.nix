{
  pkgs,
  ui,
  lib,
  config,
  ...
}: {
  options = {
    generic.fonts = {
      enable =
        lib.mkEnableOption "Enable fonts";
    };
  };

  config = lib.mkIf config.generic.fonts.enable {
    fonts.fontconfig.enable = true;
    home.packages = ui.fonts.packages pkgs;
    nixpkgs.config = {
      # Disable if you don't want unfree packages
      allowUnfree = lib.mkForce true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: lib.mkForce true;
      joypixels.acceptLicense = true;
    };
  };
}
