{inputs, ...}: {
  imports = [
    ./configuration.nix
    ../.
    ../core/sytemd-boot.nix
    ../hardware/intel.nix
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];
  
}
