{
  lib,
  isGeneric,
  self,
  desktop,
  inputs,
  profile,
  outputs,
  ...
}: let
  commonImports = [
    ./cli
    ./desktop
    ./editor
    ./bin
    ./terminal
    ./shell
    ./infosec
    ./dev
    ./common
  ];
in {
  imports =
    commonImports
    ++ [
      # profile specific home.nix
      "${self}/profiles/${profile}/home.nix"
      inputs.sops-nix.homeManagerModules.sops
    ]
    ++ lib.optionals isGeneric [./generic];

  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "sway")
    (builtins.attrValues (import "${self}/overlays/sway.nix" {inherit inputs;}))
    ++ lib.optionals (desktop == "hyprland")
    (builtins.attrValues (import "${self}/overlays/hyprland.nix" {inherit inputs;}));
}
