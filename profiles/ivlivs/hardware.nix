{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    (import ./disks.nix {inherit lib;})
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-prime
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-hidpi
    ../../system/hardware/bluetooth.nix
    ../../system/hardware/audioengine.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
