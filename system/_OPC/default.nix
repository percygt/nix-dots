{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../.
    ../core/sytemd-boot.nix
    ../hardware/intel.nix
  ];
}
