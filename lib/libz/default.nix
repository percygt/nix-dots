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
    desktop ? null,
    system ? "x86_64-linux",
    username ? defaultUser,
  }: let
    inherit (inputs.nixpkgs) lib;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        stateVersion
        profile
        desktop
        useIso
        username
        ;
    };
  in
    lib.nixosSystem {
      inherit system;
      modules = [
        "${self}/profiles/${profile}/configuration.nix"
        inputs.self.outputs.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            # useGlobalPkgs = true;
            # useUserPackages = true;
            extraSpecialArgs = mkArgs.args;
            users.${mkArgs.args.username}.imports = [
              "${self}/profiles/${profile}/home.nix"
              inputs.self.outputs.homeManagerModules.default
            ];
          };
        }
      ];
      specialArgs = mkArgs.args;
    };

  mkHome = {
    profile,
    isGeneric ? false,
    desktop ? null,
    system ? "x86_64-linux",
    username ? defaultUser,
  }: let
    inherit (inputs.home-manager) lib;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        username
        desktop
        stateVersion
        profile
        isGeneric
        ;
    };
  in
    lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        "${self}/profiles/${profile}/home.nix"
        inputs.self.outputs.homeManagerModules.default
      ];
      extraSpecialArgs = mkArgs.args;
    };
}
