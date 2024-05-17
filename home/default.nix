{
  lib,
  isGeneric,
  self,
  desktop,
  inputs,
  profile,
  outputs,
  libx,
  ...
}: let
  commonImports = [
    ./cli
    ./desktop
    ./editor
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
    ++ lib.optionals isGeneric [
      ./generic
      libx.nixpkgsConfig
    ];

  nixpkgs = {
    overlays =
      builtins.attrValues outputs.overlays
      ++ lib.optionals (desktop == "sway")
      (builtins.attrValues (import "${self}/overlays/sway.nix" {inherit inputs;}));
  };
}
