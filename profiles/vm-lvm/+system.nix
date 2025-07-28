{ lib, inputs, ... }:
{
  # imports = [
  #   inputs.disko.nixosModules.disko
  #   ./disks.nix
  # ];
  services.spice-vdagentd.enable = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
