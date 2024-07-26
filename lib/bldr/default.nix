{
  inputs,
  outputs,
  self,
  defaultUser,
  stateVersion,
  ...
}:
{
  forAllSystems =
    function:
    inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ] (system: function inputs.nixpkgs.legacyPackages.${system});
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
          [
            outputs.nixosModules.default
            "${self}/profiles"
            "${self}/config"
          ];
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
      modules = [
        outputs.nixosModules.default
        "${self}/profiles"
        "${self}/config"
      ];
      extraSpecialArgs = mkArgs.args;
    };
}
