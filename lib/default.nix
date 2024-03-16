{
  inputs,
  self,
  defaultUser,
  stateVersion,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  mkDefault = {
    pkgs,
    profile,
    is_iso,
    homeManagerModules,
  }: rec {
    username =
      if is_iso
      then "nixos"
      else defaultUser;
    homeDirectory = "/home/${username}";
    flakeDirectory = "${homeDirectory}/nix-dots";
    colors = import ./colors.nix;
    listImports = path: modules:
      lib.forEach modules (
        mod:
          path + "/${mod}"
      );
    
    hostname = profile;

    args =
      {
        inherit
          self
          inputs
          username
          hostname
          # pkgs
          colors
          listImports
          flakeDirectory
          homeDirectory
          stateVersion
          ;
      }
      // lib.optionalAttrs is_iso {target_user = defaultUser;};
    homeConfigs =
      homeManagerModules
      ++ [
        ../home
        ../profiles/${profile}/home.nix
      ];

    users.${username} = {
      imports = homeConfigs;
    };
  };
in {
  mkNixOS = {
    profile,
    pkgs,
    system,
    nixosModules ? [],
    homeManagerModules ? [],
    is_laptop ? false,
    is_iso ? false,
  }: let
    default = mkDefault {inherit pkgs profile homeManagerModules is_iso;};
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = default.args // {inherit is_laptop;};
      modules =
        nixosModules
        ++ [
          ../system
          ../profiles/${profile}/configuration.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              inherit (default) users;
              extraSpecialArgs = default.args // {inherit is_laptop;};
            };
          }
        ];
    };

  mkHomeManager = {
    profile,
    pkgs,
    homeManagerModules ? [],
    is_generic_linux ? false,
    is_laptop ? false,
    is_iso ? false,
  }: let
    default = mkDefault {inherit pkgs profile homeManagerModules is_iso;};
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = default.homeConfigs;
      extraSpecialArgs = default.args // {inherit is_generic_linux is_laptop;};
    };
}
