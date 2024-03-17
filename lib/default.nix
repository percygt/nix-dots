{
  inputs,
  outputs,
  self,
  defaultUser,
  stateVersion,
  ...
}:{
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
    desktop ? null,
    system ? "x86_64-linux",
  }: let
    default = import ./mkDefault.nix {
      inherit
        inputs
        outputs
        self
        defaultUser
        stateVersion
        profile
        desktop
        is_laptop
        is_iso
        ;
    };
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = default.nixosModules;
      specialArgs = default.args;
    };

  mkHomeManager = {
    profile,
    system ? "x86_64-linux",
    is_generic_linux ? false,
    is_laptop ? false,
  }: let
    default = import ./mkDefault.nix {
      inherit
        inputs
        outputs
        self
        defaultUser
        stateVersion
        profile
        is_generic_linux
        is_laptop
        ;
    };
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = default.homeModules;
      extraSpecialArgs = default.args;
    };
}
