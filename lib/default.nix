{
  inputs,
  lib ? inputs.nixpkgs.lib,
  ...
}: let
  default = rec {
    username = "percygt";
    colors = (import ./colors.nix).syft;
    homeDirectory = "/home/${username}";
    flakeDirectory = "${homeDirectory}/nix-dots";
    stateVersion = "23.11";
  };
in {
  mkNixOS = {
    hostName,
    pkgs,
    system,
    stateVersion ? default.stateVersion,
    username ? default.username,
    colors ? default.colors,
    homeDirectory ? default.homeDirectory,
    flakeDirectory ? default.flakeDirectory,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs hostName flakeDirectory username stateVersion;};
      modules = [
        ../system/_${hostName}
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = {
              imports =
                [
                  ../home/_${hostName}_home.nix
                ]
                ++ lib.optional (builtins.pathExists ../personal) ../personal;
            };
            extraSpecialArgs = {
              inherit
                pkgs
                inputs
                username
                colors
                hostName
                homeDirectory
                flakeDirectory
                stateVersion
                ;
            };
          };
        }
      ];
    };

  mkHomeManager = {
    hostName,
    pkgs,
    stateVersion ? default.stateVersion,
    username ? default.username,
    colors ? default.colors,
    homeDirectory ? default.homeDirectory,
    flakeDirectory ? default.flakeDirectory,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        [
          ../home/_${hostName}_home.nix
        ]
        ++ lib.optional (builtins.pathExists ../personal) ../personal;
      extraSpecialArgs = {
        inherit
          pkgs
          inputs
          username
          colors
          hostName
          homeDirectory
          flakeDirectory
          stateVersion
          ;
      };
    };
}
