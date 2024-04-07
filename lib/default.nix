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

  mkSystem = {
    profile,
    useIso ? false,
    user_name ? defaultUser,
    desktop ? null,
    system ? "x86_64-linux",
  }: let
    inherit (inputs.nixpkgs) lib;
    username =
      if useIso
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
        useIso
        ;
    };
    nixosHomeModules = [
      inputs.home-manager.nixosModules.home-manager
      {
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
      }
    ];
  in
    lib.nixosSystem {
      inherit system;
      modules = [
        ../profiles/${profile}/configuration.nix
        inputs.self.outputs.nixosModules.default
        nixosHomeModules
      ];
      # ++ lib.optionals useIso nixosHomeModules;
      specialArgs = mkArgs.args;
    };

  mkHome = {
    profile,
    useIso ? false,
    system ? "x86_64-linux",
    user_name ? defaultUser,
    useGenericLinux ? false,
  }: let
    inherit (inputs.home-manager) lib;
    username =
      if useIso
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
        useGenericLinux
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
