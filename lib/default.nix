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
    nixosModules,
    homeManagerModules,
    desktop ? null,
    is_iso ? false,
    is_generic_linux ? false,
    is_laptop,
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
          desktop
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
        ../profiles/${profile}/home.nix
      ];

    nixosConfigs =
      nixosModules
      ++ [
        ../profiles/${profile}/configuration.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = {
              imports = homeConfigs;
            };
            extraSpecialArgs = args // {inherit is_generic_linux is_laptop;};
          };
        }
      ];
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
    desktop ? null,
  }: let
    default = mkDefault {inherit profile homeManagerModules desktop is_laptop is_iso;};
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = default.args // {inherit is_laptop;};
      modules = default.nixosConfigs;
    };

  mkHomeManager = {
    profile,
    system ? "x86_64-linux",
    homeManagerModules ? [],
    is_generic_linux ? false,
    is_laptop ? false,
  }: let
    default = mkDefault {inherit profile homeManagerModules is_generic_linux is_laptop;};
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = default.homeConfigs;
      extraSpecialArgs = default.args;
    };
}
