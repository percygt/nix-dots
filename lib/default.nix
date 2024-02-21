{inputs, self,...}: let
  inherit (inputs.nixpkgs) lib;
  listImports = path: modules:
    lib.forEach modules (
      mod:
        path + "/${mod}"
    );
  sec = builtins.fromJSON (builtins.readFile "${self}/lib/base/config.json");
  default = rec {
    username = "percygt";
    colors = (import ./colors.nix).syft;
    homeDirectory = "/home/${username}";
    flakeDirectory = "${homeDirectory}/nix-dots";
    stateVersion = "23.11";
    shellAliases = import ./aliases.nix;
    sessionVariables =
      (import ./variables.nix)
      // {FLAKE_PATH = flakeDirectory;};
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
      manual = {
        html.enable = false;
        json.enable = false;
        manpages.enable = false;
      };
      news = {
        display = "silent";
        json = lib.mkForce {};
        entries = lib.mkForce [];
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
      inherit inputs username colors listImports homeDirectory flakeDirectory sec stateVersion;
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
          default.home
          ../profiles/${profile}/home.nix
        ];
      extraSpecialArgs = {inherit pkgs profile;} // default.args;
    };
}
