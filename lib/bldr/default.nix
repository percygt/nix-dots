{
  inputs,
  self,
  stateVersion,
  defaultSystem,
  defaultDesktop,
  defaultUsername,
  ...
}:
with inputs.nixpkgs.lib;
let
  inherit (self) outputs;
  modules = [
    "${self}/profiles"
    # "${self}/configs"
    "${self}/desktop"
    "${self}/core"
    "${self}/dev"

    outputs.nixosModules.default
    (builtins.toString inputs.base)
  ];
  match = flip getAttr;
  read_dir_recursively =
    dir:
    concatMapAttrs (
      this:
      match {
        # directory = { };
        directory = mapAttrs' (subpath: nameValuePair "${this}/${subpath}") (
          read_dir_recursively "${dir}/${this}"
        );
        regular = {
          ${this} = "${dir}/${this}";
        };
        symlink = { };
      }
    ) (builtins.readDir dir);
  read-all-modules = flip pipe [
    read_dir_recursively
    (filterAttrs (flip (const (hasSuffix "+home.nix"))))
    (mapAttrs (const import))
    # (mapAttrs (const (flip toFunction params)))
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

  buildNewSystem =
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
      } // mkArgs.args;
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
      extraSpecialArgs = mkArgs.args;
    };

  buildDroid =
    {
      username ? defaultUsername,
    }:
    let
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
        system = "aarch64-linux";
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
      } // mkArgs.args;
    };
}
