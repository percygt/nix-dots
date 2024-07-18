{
  inputs,
  outputs,
  self,
  defaultUser,
  stateVersion,
  ...
}:
let
  systems = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
in
{
  forEachSystem = inputs.nixpkgs.lib.genAttrs systems;
  buildSystem =
    {
      profile,
      isIso ? false,
      desktop ? null,
      system ? "x86_64-linux",
      username ? defaultUser,
    }:
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      mkArgs = import ./mkArgs.nix {
        inherit
          inputs
          outputs
          self
          username
          desktop
          stateVersion
          profile
          isIso
          ;
      };
      homeArgs = mkArgs.args;
    in
    nixosSystem {
      inherit system;
      modules =
        if isIso then
          [ "${self}/lib/bldr/iso/${profile}/configuration.nix" ]
        else
          [ outputs.nixosModules.default ];
      specialArgs = {
        inherit homeArgs;
      } // mkArgs.args;
    };

  buildHome =
    {
      profile,
      isGeneric ? false,
      desktop ? null,
      system ? "x86_64-linux",
      username ? defaultUser,
    }:
    let
      inherit (inputs.home-manager.lib) homeManagerConfiguration;
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
    homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      # modules = [outputs.homeManagerModules.default];
      extraSpecialArgs = mkArgs.args // {
        nixosConfig = { };
      };
    };
}
