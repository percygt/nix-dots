{
  self,
  inputs,
  desktop,
  lib,
  profile,
  outputs,
  libx,
  ...
}: let
  commonImports = [
    ./common
    ./core
    ./drivers
    ./desktop
    ./users
    ./infosec
    ./net
    ./extras
    ./virtualisation
    ./cli
    ./dev
    ./editor
    ./shell
  ];
in {
  imports =
    commonImports
    ++ [
      # profile specific configuration.nix
      "${self}/profiles/${profile}/configuration.nix"
      inputs.disko.nixosModules.disko
      inputs.impermanence.nixosModules.impermanence
      inputs.sops-nix.nixosModules.sops
      inputs.nix-flatpak.nixosModules.nix-flatpak
      libx.nixpkgsConfig
    ];

  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "sway")
    (builtins.attrValues (import "${self}/overlays/sway.nix" {inherit inputs;}));
}
