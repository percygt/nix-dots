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
      host,
      extraModulesDir,
    }:
    (
      [
        "${self}/common"
        "${self}/modules"
        "${self}/hosts/${host}"
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
      host,
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
          host
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
          inherit desktop host extraModulesDir;
        })
        ++ [
          self.outputs.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.${username}.imports = libx.importHomeForEachDir (defaultDirs {
                inherit desktop host extraModulesDir;
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
      host,
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
          host
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
          inherit desktop host extraModulesDir;
        })
        ++ [
          self.outputs.homeManagerModules.default
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
