{
  inputs,
  self,
  stateVersion,
  defaultSystem,
  defaultDesktop,
  defaultUsername,
  ...
}:
let
  inherit (self) outputs;
  modules = [
    "${self}/profiles"
    "${self}/configs"
    outputs.nixosModules.default
    (builtins.toString inputs.base)
  ];
in
rec {
  supportedSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  forAllSystems =
    function:
    inputs.nixpkgs.lib.genAttrs supportedSystems (
      system: function inputs.nixpkgs.legacyPackages.${system}
    );

  stable =
    system:
    import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };

  master =
    system:
    import inputs.nixpkgs-master {
      inherit system;
      config.allowUnfree = true;
    };
  buildSystem =
    {
      profile,
      isIso ? false,
      system ? defaultSystem,
      desktop ? defaultDesktop,
      username ? defaultUsername,
    }:
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      mkArgs = import ./mkArgs.nix {
        inherit
          inputs
          outputs
          self
          desktop
          profile
          isIso
          username
          stateVersion
          ;
      };
    in
    nixosSystem {
      inherit system modules;
      specialArgs = {
        homeArgs = mkArgs.args;
        pkgs-stable = stable system;
        pkgs-master = master system;
      } // mkArgs.args;
    };

  buildHome =
    {
      profile,
      isGeneric ? false,
      system ? defaultSystem,
      desktop ? defaultDesktop,
      username ? defaultUsername,
    }:
    let
      inherit (inputs.home-manager.lib) homeManagerConfiguration;
      mkArgs = import ./mkArgs.nix {
        inherit
          inputs
          outputs
          self
          desktop
          profile
          isGeneric
          username
          stateVersion
          ;
        homeMarker = true;
      };
    in
    homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      inherit modules;
      extraSpecialArgs = {
        pkgs-stable = stable system;
        pkgs-master = master system;
      } // mkArgs.args;
    };

  buildDroid =
    {
      username ? defaultUsername,
    }:
    let
      system = "aarch64-linux";
      inherit (inputs.nix-on-droid.lib) nixOnDroidConfiguration;
      mkArgs = import ./mkArgs.nix {
        inherit
          inputs
          outputs
          self
          username
          stateVersion
          ;
        isDroid = true;
      };
    in
    nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues outputs.overlays ++ [
          inputs.nix-on-droid.overlays.default
        ];
      };
      # inherit modules;
      modules = [
        # "${self}/profiles"
        "${self}/configs"
        outputs.nixosModules.default
        # (builtins.toString inputs.base)
      ];
      extraSpecialArgs = {
        homeArgs = mkArgs.args;
        pkgs-stable = stable system;
        pkgs-master = master system;
      } // mkArgs.args;
    };
}
