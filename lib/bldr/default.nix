{
  inputs,
  self,
  stateVersion,
  defaultSystem,
  defaultDesktop,
  defaultUsername,
  ...
}:
let
  inherit (self) outputs;
  modules = [
    "${self}/profiles"
    "${self}/configs"
    outputs.nixosModules.default
    (builtins.toString inputs.base)
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
      system ? defaultSystem,
      desktop ? defaultDesktop,
      username ? defaultUsername,
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
          stateVersion
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
      system ? defaultSystem,
      desktop ? defaultDesktop,
      username ? defaultUsername,
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
          stateVersion
          ;
        homeMarker = true;
      };
    in
    homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      inherit modules;
      extraSpecialArgs = mkArgs.args;
    };

  buildDroid =
    {
      username ? defaultUsername,
    }:
    let
      inherit (inputs.nix-on-droid.lib) nixOnDroidConfiguration;
      mkArgs = import ./mkArgs.nix {
        inherit
          inputs
          outputs
          self
          username
          stateVersion
          ;
        isDroid = true;
      };
      system = "aarch64-linux";
    in
    nixOnDroidConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      # inherit modules;
      modules = [
        # "${self}/profiles"
        "${self}/configs"
        outputs.nixosModules.default
        # (builtins.toString inputs.base)
      ];
      extraSpecialArgs = {
        homeArgs = mkArgs.args;
      } // mkArgs.args;
    };
}
