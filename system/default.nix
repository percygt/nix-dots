{
  self,
  inputs,
  desktop,
  lib,
  profile,
  outputs,
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
    ./virtualisation
  ];
in {
  imports =
    commonImports
    ++ [
      # profile specific configuration.nix
      "${self}/profiles/${profile}/configuration.nix"
      inputs.sops-nix.nixosModules.sops
      inputs.nix-flatpak.nixosModules.nix-flatpak
    ];

  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "sway")
    (builtins.attrValues (import "${self}/overlays/sway.nix" {inherit inputs;}))
    ++ lib.optionals (desktop == "hyprland")
    (builtins.attrValues (import "${self}/overlays/hyprland.nix" {inherit inputs;}));
}
