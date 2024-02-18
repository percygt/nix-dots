{inputs, ...}: let
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
      specialArgs = {inherit inputs hostName username stateVersion;};
      modules = [
        ../system/_profiles/${hostName}
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ../home/_${hostName}_home.nix;
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
      modules = [
        ../home/_${hostName}_home.nix
      ];
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
