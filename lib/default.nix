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

  mkSystem = {
    profile,
    useIso ? false,
    user ? defaultUser,
    desktop ? null,
    system ? "x86_64-linux",
  }: let
    inherit (inputs.nixpkgs) lib;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        user
        defaultUser
        stateVersion
        profile
        desktop
        useIso
        ;
    };
  in
    lib.nixosSystem {
      inherit system;
      modules = [
        ../profiles/${profile}/configuration.nix
        inputs.self.outputs.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = mkArgs.args;
        }
      ];
      specialArgs = mkArgs.args;
    };

  mkHome = {
    profile,
    system ? "x86_64-linux",
    user ? defaultUser,
  }: let
    inherit (inputs.home-manager) lib;
    isGeneric = true;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        user
        defaultUser
        stateVersion
        profile
        isGeneric
        ;
    };
  in
    lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        ../profiles/${profile}/home.nix
        inputs.self.outputs.homeManagerModules.default
      ];
      extraSpecialArgs = mkArgs.args;
    };
}
