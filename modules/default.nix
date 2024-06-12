{
  self,
  inputs,
  desktop,
  lib,
  profile,
  outputs,
  username,
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
  homePathList =
    builtins.filter (path: builtins.pathExists path) (map (dir: ./${dir}/home.nix)
      (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix" "home.nix"])));
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

  home-manager.users.${username}.imports = homePathList;

  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "sway")
    (builtins.attrValues (import "${self}/overlays/sway.nix" {inherit inputs;}));
}
