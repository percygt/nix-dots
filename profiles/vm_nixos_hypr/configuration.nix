{listImports, ...}: let
  modules = [
    "common"
    "network"
    "hardware"
    "programs/xdg.nix"
    "services"
    "security"
  ];
in {
  imports =
    [
      ./disks.nix
      ./hardware.nix
      ./boot.nix
    ]
    ++ listImports ../../system modules;
}
