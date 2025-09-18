{
  inputs,
  self,
  stateVersion,
  defaultSystem,
  defaultUsername,
  ...
}:
let
  inherit (self) outputs;
  lib = inputs.home-manager.lib // inputs.nixpkgs.lib;
  libx = import "${self}/lib/libx" { inherit lib inputs; };
  defaultDirs =
    {
      desktop,
      profile,
      extraModules,
    }:
    (
      [
        "${self}/core"
        "${self}/dev"
        "${self}/profiles/${profile}"
        "${self}/modules"
      ]
      ++ extraModules
      ++ lib.optionals (desktop != null) [
        "${self}/desktop/common"
        "${self}/desktop/${desktop}"
      ]
    );
  supportedSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
  colorize = inputs.nix-colorizer;
in
{
  forAllSystems =
    function: lib.genAttrs supportedSystems (system: function inputs.nixpkgs.legacyPackages.${system});

  buildSystem =
    {
      profile,
      system ? defaultSystem,
      desktop ? null,
      username ? defaultUsername,
      extraModules ? [ ],
    }:
    let
      inherit (lib) nixosSystem;
      homeDirectory = "/home/${username}";
      args = {
        inherit
          self
          inputs
          outputs
          profile
          username
          libx
          homeDirectory
          stateVersion
          desktop
          colorize
          ;
      };
    in
    nixosSystem {
      inherit system;
      modules =
        libx.importNixosForEachDir (defaultDirs {
          inherit desktop profile extraModules;
        })
        ++ [
          self.outputs.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.${username}.imports = libx.importHomeForEachDir (defaultDirs {
                inherit desktop profile extraModules;
              });
              extraSpecialArgs = args;
            };
          }
        ];
      specialArgs = args;
    };

  buildHome =
    {
      profile,
      system ? defaultSystem,
      desktop ? null,
      username ? defaultUsername,
      extraModules ? [ ],
    }:
    let
      inherit (lib) homeManagerConfiguration;
      homeDirectory = "/home/${username}";
      args = {
        inherit
          self
          inputs
          outputs
          profile
          username
          libx
          homeDirectory
          stateVersion
          desktop
          colorize
          ;
      };
    in
    homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules =
        libx.importHomeForEachDir (defaultDirs {
          inherit desktop profile extraModules;
        })
        ++ [
          self.outputs.homeManagerModules.default
          inputs.niri.homeModules.niri
          (
            { pkgs, ... }:
            {
              nix.package = pkgs.nix;
            }
          )
        ];
      extraSpecialArgs = args;
    };
}
