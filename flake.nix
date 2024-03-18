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
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";
    hypridle.url = "github:hyprwm/hypridle";
    hypridle.inputs.nixpkgs.follows = "nixpkgs";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    nix-colors.url = "github:misterio77/nix-colors";
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
      };
      vm_nixos_hypr = libx.mkNixOS {
        profile = "vm_nixos_hypr";
        desktop = "hyprland";
      };
      dot_iso = libx.mkNixOS {
        profile = "dot_iso";
        is_iso = true;
      };
    };

    homeConfigurations = {
      ivlivs = libx.mkHomeManager {
        profile = "fates";
      };
      vm_nixos_hypr = libx.mkHomeManager {
        profile = "vm_nixos_hypr";
      };
      furies = libx.mkHomeManager {
        profile = "furies";
        is_generic_linux = true;
        is_laptop = true;
      };
      fates = libx.mkHomeManager {
        profile = "fates";
        is_generic_linux = true;
      };
    };
  };
}
