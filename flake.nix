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

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

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

    libz = import ./lib {inherit self inputs outputs defaultUser stateVersion;};
  in {
    packages = libz.forEachSystem (system: (import ./packages {
      pkgs = nixpkgs.legacyPackages.${system};
    }));

    devShells = libz.forEachSystem (system: (import ./shell.nix {
      pkgs = nixpkgs.legacyPackages.${system};
    }));

    formatter = libz.forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    templates = import ./templates;

    nixosModules.default = ./system;

    nixosConfigurations = {
      aizeft = libz.mkSystem {
        profile = "aizeft";
        desktop = "sway";
      };
      vm-lvm = libz.mkSystem {
        profile = "vm-lvm";
        desktop = "sway";
      };
      minimal = libz.mkSystem {
        profile = "minimal";
        isIso = true;
      };
      graphical = libz.mkSystem {
        profile = "graphical";
        isIso = true;
      };
    };

    homeManagerModules.default = ./home;

    homeConfigurations = {
      aizeft = libz.mkHome {
        profile = "aizeft";
        desktop = "sway";
      };
      furies = libz.mkHome {
        profile = "furies";
        desktop = "sway";
        isGeneric = true;
      };
      fates = libz.mkHome {
        profile = "fates";
        desktop = "gnome";
        isGeneric = true;
      };
    };
  };
}
