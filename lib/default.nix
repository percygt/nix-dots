{inputs, ...}: let
  default = rec {
    username = "percygt";
    colors = (import ./colors.nix).syft;
    shellAliases = import ./aliases.nix;
    sessionVariables = import ./variables.nix;
    homeDirectory = "/home/${username}";
    flakeDirectory = "${homeDirectory}/nix-dots";
    stateVersion = "23.11";
    configuration = {
      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
          "input"
          "networkmanager"
          "video"
          "wheel"
          "audio"
        ];
      };
    };
    home = {
      programs.home-manager.enable = true;
      news.display = "silent";
      manual = {
        html.enable = false;
        json.enable = false;
        manpages.enable = false;
      };
      home = {
        inherit
          username
          homeDirectory
          stateVersion
          shellAliases
          sessionVariables
          ;
      };
    };
    args = {
      inherit inputs username colors homeDirectory flakeDirectory stateVersion;
    };
  };
in {
  mkNixOS = {
    profile,
    pkgs,
    system,
    nixosModules ? [],
    homeManagerModules ? [],
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = default.args;
      modules =
        nixosModules
        ++ [
          default.configuration
          ../profiles/${profile}/configuration.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${default.username} = {
                imports =
                  homeManagerModules
                  ++ [
                    default.home
                    ../profiles/${profile}/home.nix
                  ];
              };
              extraSpecialArgs = {inherit pkgs profile;} // default.args;
            };
          }
        ];
    };

  mkHomeManager = {
    profile,
    pkgs,
    homeManagerModules ? [],
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        homeManagerModules
        ++ [
          default.hm
          {targets.genericLinux.enable = true;}
          ../profiles/${profile}/home.nix
        ];
      extraSpecialArgs = {inherit pkgs profile;} // default.args;
    };
}
