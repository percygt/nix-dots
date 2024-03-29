{
  inputs,
  outputs,
  self,
  defaultUser,
  stateVersion,
  ...
}: {
  forEachSystem = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  mkNixOS = {
    profile,
    is_laptop ? false,
    is_iso ? false,
    userName ? defaultUser,
    desktop ? null,
    system ? "x86_64-linux",
  }: let
    inherit (inputs.nixpkgs) lib;
    username =
      if is_iso
      then "nixos"
      else userName;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        username
        stateVersion
        profile
        desktop
        is_laptop
        is_iso
        ;
    };
  in
    lib.nixosSystem {
      inherit system;
      modules = [
        ../profiles/${profile}/configuration.nix
      ];
      specialArgs = mkArgs.args;
    };

  mkHomeManager = {
    profile,
    system ? "x86_64-linux",
    userName ? defaultUser,
    is_generic_linux ? false,
    is_laptop ? false,
  }: let
    inherit (inputs.home-manager) lib;
    username = userName;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        username
        stateVersion
        profile
        is_generic_linux
        is_laptop
        ;
    };
  in
    lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        ../profiles/${profile}/home.nix
      ];
      extraSpecialArgs = mkArgs.args;
    };
}
