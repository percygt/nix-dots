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
    xremap.url = "github:xremap/nix-flake";
    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    # lanzaboote.url = "github:nix-community/lanzaboote";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    sikreto = {
      url = "git+ssh://git@gitlab.com/percygt/sikreto.git?ref=main&shallow=1";
      flake = false;
    };
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
    packages = libx.forEachSystem (system: (import ./packages {
      pkgs = nixpkgs.legacyPackages.${system};
    }));

    devShells = libx.forEachSystem (system: (import ./shell.nix {
      pkgs = nixpkgs.legacyPackages.${system};
    }));

    formatter = libx.forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays.nix {inherit inputs;};

    templates = import ./templates;

    nixosModules.default = ./system;

    nixosConfigurations = {
      cryo = libx.mkSystem {
        profile = "cryo";
        desktop = "gnome";
      };
      aizeft = libx.mkSystem {
        profile = "aizeft";
        desktop = "hyprland";
      };
      vm-hypr = libx.mkSystem {
        profile = "vm-hypr";
        desktop = "hyprland";
      };
      vm-gnome = libx.mkSystem {
        profile = "vm-gnome";
        desktop = "gnome";
      };
      dot-iso = libx.mkSystem {
        profile = "dot-iso";
        useIso = true;
      };
    };

    homeManagerModules.default = ./home;

    homeConfigurations = {
      cryo = libx.mkHome {
        profile = "cryo";
      };
      aizeft = libx.mkHome {
        profile = "aizeft";
      };
      vm-hypr = libx.mkHome {
        profile = "vm-hypr";
      };
      vm-gnome = libx.mkHome {
        profile = "vm-gnome";
      };
      furies = libx.mkHome {
        profile = "furies";
        useGenericLinux = true;
      };
      fates = libx.mkHome {
        profile = "fates";
        useGenericLinux = true;
      };
    };
  };
}
