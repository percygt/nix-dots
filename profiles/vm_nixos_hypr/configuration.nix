{
  listImports,
  inputs,
  ...
}: let
  modules = [
    "."
    "desktop"
    # "hardware"
    # "programs/xdg.nix"
    # "services"
    # "security"
  ];
in {
  imports =
    listImports ../../system modules
    ++ [
      inputs.home-manager.nixosModules.default
      ./hardware.nix
      ./disks.nix
      ./boot.nix
    ];
}
