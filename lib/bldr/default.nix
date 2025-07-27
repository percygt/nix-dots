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
    "${self}/desktop"
    # "${self}/core"
    # "${self}/dev"
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
      libx = import "${self}/lib/libx" {
        inherit
          inputs
          username
          ;
      };
    in
    nixosSystem {
      inherit system;
      modules =
        [ inputs.home-manager.nixosModules.home-manager ]
        ++ modules
        ++ libx.import_nixosmodules "${self}/core"
        ++ libx.import_nixosmodules "${self}/dev"
        ++ libx.import_nixosmodules outputs.nixosModules.default
        ++ [
          {
            home-manager = {
              users.${username}.imports =
                libx.import_hmmodules "${self}/core"
                ++ libx.import_hmmodules "${self}/dev"
                ++ libx.import_hmmodules outputs.nixosModules.default;
              extraSpecialArgs = mkArgs.args // {
                inherit (mkArgs) args;
              };
            };
          }
        ];
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
      libx = import "${self}/lib/libx" {
        inherit
          inputs
          username
          ;
      };
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
      modules =
        modules
        ++ libx.import_hmmodules "${self}/core"
        ++ libx.import_hmmodules "${self}/dev"
        ++ libx.import_hmmodules outputs.nixosModules.default
        ++ [
          (
            { pkgs, ... }:
            {
              nix.package = pkgs.nix;
            }
          )
        ];
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
    in
    nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "aarch64-linux";
        overlays = builtins.attrValues outputs.overlays ++ [
          inputs.nix-on-droid.overlays.default
        ];
      };
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
