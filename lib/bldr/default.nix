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
  lib = inputs.home-manager.lib // inputs.nixpkgs.lib;
  libx = import "${self}/lib/libx" { inherit lib; };
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
        self.outputs.nixosModules.default
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

in
{
  forAllSystems =
    function: lib.genAttrs supportedSystems (system: function inputs.nixpkgs.legacyPackages.${system});

  buildSystem =
    {
      profile,
      system ? defaultSystem,
      desktop ? defaultDesktop,
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
      desktop ? defaultDesktop,
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
