{
  inputs,
  outputs,
  self,
  defaultUser,
  stateVersion,
  ...
}: {
  forEachSystem = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  mkNixOS = {
    profile,
    is_laptop ? false,
    is_iso ? false,
    user_name ? defaultUser,
    desktop ? null,
    system ? "x86_64-linux",
  }: let
    inherit (inputs.nixpkgs) lib;
    username =
      if is_iso
      then "nixos"
      else user_name;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        username
        defaultUser
        stateVersion
        profile
        desktop
        is_laptop
        is_iso
        ;
    };
    nixosHomeModule = {
      home-manager = {
        extraSpecialArgs = mkArgs.args;
        useUserPackages = true;
        users.${username} = {
          imports = [
            ../profiles/${profile}/home.nix
            inputs.self.outputs.homeManagerModules.default
          ];
        };
      };
    };
  in
    lib.nixosSystem {
      inherit system;
      modules =
        [
          ../profiles/${profile}/configuration.nix
          inputs.self.outputs.nixosModules.default
          (lib.optionalAttrs
            is_iso
            nixosHomeModule)
        ]
        ++ lib.optionals is_iso [
          inputs.home-manager.nixosModules.home-manager
        ];
      specialArgs = mkArgs.args;
    };

  mkHomeManager = {
    profile,
    system ? "x86_64-linux",
    user_name ? defaultUser,
    is_generic_linux ? false,
    is_laptop ? false,
  }: let
    inherit (inputs.home-manager) lib;
    username = user_name;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        username
        defaultUser
        stateVersion
        profile
        is_generic_linux
        is_laptop
        ;
    };
  in
    lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        ../profiles/${profile}/home.nix
        inputs.self.outputs.homeManagerModules.default
      ];
      extraSpecialArgs = mkArgs.args;
    };
}
