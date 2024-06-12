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
  ];
in {
  imports =
    commonImports
    ++ [
      # profile specific configuration.nix
      "${self}/profiles/${profile}/configuration.nix"
      libx.nixpkgsConfig
    ];

  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "sway")
    (builtins.attrValues (import "${self}/overlays/sway.nix" {inherit inputs;}));
}
