{ inputs, self, ... }:
let
  inherit (self) outputs;
  modules = [
    "${self}/profiles"
    "${self}/config"
    outputs.nixosModules.default
  ];
in
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
    }:
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      mkArgs = import ./mkArgs.nix {
        inherit
          inputs
          outputs
          self
          desktop
          profile
          isIso
          ;
      };
      homeArgs = mkArgs.args;
    in
    nixosSystem {
      inherit system modules;
      specialArgs = {
        inherit homeArgs;
      } // mkArgs.args;
    };

  buildHome =
    {
      profile,
      isGeneric ? true,
      desktop ? null,
      system ? "x86_64-linux",
    }:
    let
      inherit (inputs.home-manager.lib) homeManagerConfiguration;
      mkArgs = import ./mkArgs.nix {
        inherit
          inputs
          outputs
          self
          desktop
          profile
          isGeneric
          ;
      };
    in
    homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      inherit modules;
      extraSpecialArgs = mkArgs.args;
    };
}
