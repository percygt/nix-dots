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
    (builtins.toString inputs.general)
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
          username
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
      isGeneric ? false,
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
          username
          ;
        homeMarker = true;
      };
    in
    homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      inherit modules;
      extraSpecialArgs = mkArgs.args;
    };
}
