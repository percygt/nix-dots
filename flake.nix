{
  description = "PercyGT's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nix-stash.url = "github:percygt/nix-stash";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "unstable";
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";
    hypridle.url = "github:hyprwm/hypridle";
    hypridle.inputs.nixpkgs.follows = "nixpkgs";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    # lanzaboote.url = "github:nix-community/lanzaboote";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs = {
    nixpkgs,
    self,
    ...
  } @ inputs: let
    inherit (self) outputs;
    defaultUser = "percygt";
    stateVersion = "23.11";
    nix-personal = nixpkgs.lib.optional (builtins.pathExists ./personal) ./personal;
    libx = import ./lib {inherit self inputs outputs defaultUser stateVersion;};
  in {
    overlays = import ./overlays.nix {inherit inputs;};

    formatter = libx.forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = libx.forEachSystem (system: (import ./packages {pkgs = nixpkgs.legacyPackages.${system};}));

    devShells = libx.forEachSystem (system: (import ./shell.nix {
      pkgs = nixpkgs.legacyPackages.${system};
    }));

    templates = import ./templates;

    nixosConfigurations = {
      ivlivs = libx.mkNixOS {
        profile = "ivlivs";
        desktop = "hyprland";
        nixosModules = [
          inputs.home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
        ];
        homeManagerModules = [
          # inputs.hyprland.homeManagerModules.default
          inputs.hypridle.homeManagerModules.default
          inputs.hyprlock.homeManagerModules.default
        ];
      };
      vm_nixos_hypr = libx.mkNixOS {
        profile = "vm_nixos_hypr";
        desktop = "hyprland";
        nixosModules = [
          inputs.home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
        ];
        homeManagerModules = [
          # inputs.hyprland.homeManagerModules.default
          inputs.hypridle.homeManagerModules.default
          inputs.hyprlock.homeManagerModules.default
        ];
      };
      dot_iso = libx.mkNixOS {
        profile = "dot_iso";
        is_iso = true;
        nixosModules = [
          {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    };

    homeConfigurations = {
      ivlivs = libx.mkHomeManager {
        profile = "fates";
        homeManagerModules =
          nix-personal
          ++ [
            # inputs.hyprland.homeManagerModules.default
            inputs.hypridle.homeManagerModules.default
            inputs.hyprlock.homeManagerModules.default
            inputs.sops-nix.homeManagerModules.sops
          ];
      };
      vm_nixos_hypr = libx.mkHomeManager {
        profile = "vm_nixos_hypr";
        homeManagerModules =
          nix-personal
          ++ [
            # inputs.hyprland.homeManagerModules.default
            inputs.hypridle.homeManagerModules.default
            inputs.hyprlock.homeManagerModules.default
            inputs.sops-nix.homeManagerModules.sops
          ];
      };
      furies = libx.mkHomeManager {
        profile = "furies";
        is_generic_linux = true;
        is_laptop = true;
        homeManagerModules = nix-personal;
      };
      fates = libx.mkHomeManager {
        profile = "fates";
        is_generic_linux = true;
        homeManagerModules = nix-personal;
      };
    };
  };
}
