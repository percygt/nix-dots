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
  commonHomeImports = [
    ./cli/home.nix
    ./desktop/home.nix
    ./editor/home.nix
    ./terminal/home.nix
    ./shell/home.nix
    ./infosec/home.nix
    ./dev/home.nix
    ./common/home.nix
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

  home-manager.users.${username} = {
    config,
    isGeneric,
    ...
  }: {
    imports =
      commonHomeImports
      ++ [
        # profile specific home.nix
        "${self}/profiles/${profile}/home.nix"
        inputs.sops-nix.homeManagerModules.sops
      ]
      ++ lib.optionals isGeneric [
        ./generic/home.nix
        libx.nixpkgsConfig
      ];
    nixpkgs.overlays =
      builtins.attrValues outputs.overlays
      ++ lib.optionals (desktop == "sway")
      (builtins.attrValues (import "${self}/overlays/sway.nix" {inherit inputs;}));
  };

  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "sway")
    (builtins.attrValues (import "${self}/overlays/sway.nix" {inherit inputs;}));
}
