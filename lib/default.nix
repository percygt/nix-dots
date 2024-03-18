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
    desktop ? null,
    system ? "x86_64-linux",
  }: let
    mkArgs = import ./mkArgs.nix {
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
      modules = [
        ../profiles/${profile}/configuration.nix
        # {
        #   home-manager = {
        #     useGlobalPkgs = true;
        #     useUserPackages = true;
        #     users.${username} = {
        #       imports = homeModules;
        #     };
        #     extraSpecialArgs = args;
        #   };
        # }
      ];
      specialArgs = mkArgs.args;
    };

  mkHomeManager = {
    profile,
    system ? "x86_64-linux",
    is_generic_linux ? false,
    is_laptop ? false,
  }: let
    mkArgs = import ./mkArgs.nix {
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
      modules = [
        ../profiles/${profile}/home.nix
      ];
      extraSpecialArgs = mkArgs.args;
    };
}
