{
  inputs,
  self,
  username,
  ...
}:
let
  inherit (self) outputs;
  modules = [
    "${self}/profiles"
    "${self}/config"
    outputs.nixosModules.default
  ];
in
rec {
  supportedSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
  forAllSystems =
    function:
    inputs.nixpkgs.lib.genAttrs supportedSystems (
      system: function inputs.nixpkgs.legacyPackages.${system}
    );

  buildSystem =
    {
      profile,
      isIso ? false,
      desktop ? null,
      system ? "x86_64-linux",
      buildAll ? true,
    }:
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      buildMarker = if buildAll then "all" else "system";
      mkArgs = import ./mkArgs.nix {
        inherit
          inputs
          outputs
          self
          desktop
          profile
          isIso
          username
          buildMarker
          ;
      };
    in
    nixosSystem {
      inherit system modules;
      specialArgs = {
        homeArgs = mkArgs.args;
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
      buildMarker = "home";
      mkArgs = import ./mkArgs.nix {
        inherit
          inputs
          outputs
          self
          desktop
          profile
          isGeneric
          username
          buildMarker
          ;
      };
    in
    homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      inherit modules;
      extraSpecialArgs = mkArgs.args;
    };
}
