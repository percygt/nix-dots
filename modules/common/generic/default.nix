{ lib, pkgs, ... }:
{
  imports = [
    ./xremap.nix
    ./fonts.nix
    ./bluez-suspend.nix
    ./packages.nix
    ./nvd.nix
    ./overlays.nix
    ./theme.nix
    ../common/nixpkgs/config.nix
  ];
  generic = {
    # overlays.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true;
    packages.enable = lib.mkDefault true;
    bluez-suspend.disable = lib.mkDefault true;
  };
  home.packages = import ../packages.nix pkgs;
}
