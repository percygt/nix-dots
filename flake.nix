{
  description = "PercyGT's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nix-stash.url = "github:percygt/nix-stash";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

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
      aizeft = libx.mkSystem {
        profile = "aizeft";
        desktop = "hyprland";
      };
      cryo = libx.mkSystem {
        profile = "cryo";
        desktop = "gnome";
      };
      vm-lvm = libx.mkSystem {
        profile = "vm-lvm";
      };
      vm-hypr = libx.mkSystem {
        profile = "vm-hypr";
      };
      vm-gnome = libx.mkSystem {
        profile = "vm-gnome";
        desktop = "gnome";
      };
      iso-tty = libx.mkSystem {
        profile = "iso-tty";
        useIso = true;
      };
      iso-gnome = libx.mkSystem {
        profile = "iso-gnome";
        useIso = true;
      };
    };

    homeManagerModules.default = ./home;

    homeConfigurations = {
      vm-gnome = libx.mkHome {
        profile = "vm-gnome";
      };
      furies = libx.mkHome {
        profile = "furies";
        isGeneric = true;
      };
      fates = libx.mkHome {
        profile = "fates";
        isGeneric = true;
      };
    };
  };
}
