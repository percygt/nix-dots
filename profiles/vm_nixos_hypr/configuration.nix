{
  listSystemImports,
  ...
}: let
  modules = [
    "."
    "desktop"
  ];
in {
  imports =
    listSystemImports modules
    ++ [
      # inputs.home-manager.nixosModules.default
      ./hardware.nix
      ./disks.nix
      ./boot.nix
    ];
}
