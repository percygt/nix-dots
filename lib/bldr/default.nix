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
      extraModulesDir,
    }:
    (
      [
        "${self}/config"
        "${self}/modules"
        "${self}/profiles/${profile}"
      ]
      ++ extraModulesDir
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
      extraModulesDir ? [ ],
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
          inherit desktop profile extraModulesDir;
        })
        ++ [
          self.outputs.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.${username}.imports = libx.importHomeForEachDir (defaultDirs {
                inherit desktop profile extraModulesDir;
              });
              extraSpecialArgs = args // {
                inherit args;
              };
            };
          }
        ];
      specialArgs = args // {
        inherit args;
      };
    };

  buildHome =
    {
      profile,
      system ? defaultSystem,
      desktop ? null,
      username ? defaultUsername,
      extraModulesDir ? [ ],
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
          inherit desktop profile extraModulesDir;
        })
        ++ [
          self.outputs.homeManagerModules.default
          # need to make home-manager work both as a standalone and a nixos module
          inputs.niri.homeModules.niri
          (
            { pkgs, ... }:
            {
              nix.package = pkgs.nix;
            }
          )
        ];
      extraSpecialArgs = args // {
        inherit args;
      };
    };
}
