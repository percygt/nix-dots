{
  inputs,
  outputs,
  self,
  defaultUser,
  stateVersion,
  ...
}: let
  nixpkgsOverlays = {
    desktop,
    lib,
  }: {
    nixpkgs.overlays =
      (builtins.attrValues (import "${self}/overlays/common.nix" {inherit inputs;}))
      ++ lib.optionals (desktop == "sway")
      (builtins.attrValues (import "${self}/overlays/sway.nix" {inherit inputs;}));
  };
  homeModules = {
    profile,
    desktop,
    lib,
    useIso ? false,
  }:
    [
      (nixpkgsOverlays {inherit desktop lib;})
      "${self}/profiles/${profile}/home.nix"
    ]
    ++ lib.optionals (!useIso) [
      outputs.homeManagerModules.default
      inputs.sops-nix.homeManagerModules.sops
    ];
in {
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
    desktop ? null,
    system ? "x86_64-linux",
    username ? defaultUser,
  }: let
    inherit (inputs.nixpkgs) lib;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        stateVersion
        profile
        desktop
        useIso
        username
        ;
    };
  in
    lib.nixosSystem {
      inherit system;
      modules =
        [
          "${self}/profiles/${profile}/configuration.nix"
          (nixpkgsOverlays {inherit desktop lib;})
        ]
        ++ lib.optionals (!useIso) [
          inputs.sops-nix.nixosModules.sops
          outputs.nixosModules.default
        ]
        ++ lib.optionals
        (builtins.pathExists "${self}/profiles/${profile}/home.nix")
        [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = mkArgs.args;
              users.${mkArgs.args.username}.imports = homeModules {inherit profile desktop lib useIso;};
            };
          }
        ];
      specialArgs = mkArgs.args;
    };

  mkHome = {
    profile,
    isGeneric ? false,
    desktop ? null,
    system ? "x86_64-linux",
    username ? defaultUser,
  }: let
    lib = inputs.nixpkgs.lib // inputs.home-manager.lib;
    mkArgs = import ./mkArgs.nix {
      inherit
        inputs
        outputs
        self
        username
        desktop
        stateVersion
        profile
        isGeneric
        ;
    };
  in
    lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = homeModules {inherit profile desktop lib;};
      extraSpecialArgs = mkArgs.args;
    };
}
