{
  inputs,
  outputs,
  self,
  defaultUser,
  stateVersion,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  mkDefault = {
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

    hostName = profile;

    args =
      {
        inherit
          self
          inputs
          outputs
          username
          hostName
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
  forEachSystem = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  mkNixOS = {
    profile,
    nixosModules ? [],
    homeManagerModules ? [],
    is_laptop ? false,
    is_iso ? false,
  }: let
    default = mkDefault {inherit profile homeManagerModules is_iso;};
  in
    inputs.nixpkgs.lib.nixosSystem {
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
    system ? "x86_64-linux",
    homeManagerModules ? [],
    is_generic_linux ? false,
    is_laptop ? false,
    is_iso ? false,
  }: let
    default = mkDefault {inherit profile homeManagerModules is_iso;};
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules =
        default.homeConfigs
        ++ [
          {
            nixpkgs = {
              overlays = builtins.attrValues outputs.overlays;
              config = {
                # Disable if you don't want unfree packages
                allowUnfree = true;
                # Workaround for https://github.com/nix-community/home-manager/issues/2942
                allowUnfreePredicate = _: true;
                permittedInsecurePackages = [
                  "electron-25.9.0"
                ];
              };
            };
          }
        ];
      extraSpecialArgs = default.args // {inherit is_generic_linux is_laptop;};
    };
}
