{
  description = "PercyGT's nix config";

  inputs = {
    nix-stash.url = "github:percygt/nix-stash";

    nixpkgs.follows = "nix-stash/nixpkgs";
    nixpkgs-stable.follows = "nix-stash/nixpkgs-stable";

    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs-stable";

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
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # lanzaboote.url = "github:nix-community/lanzaboote";

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

    bldr = import ./lib {inherit self inputs outputs defaultUser stateVersion;};
  in {
    packages = bldr.forEachSystem (system: (import ./packages {
      pkgs = nixpkgs.legacyPackages.${system};
    }));

    formatter = bldr.forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    templates = import ./templates;

    nixosModules.default = ./system;

    nixosConfigurations = {
      aizeft = bldr.buildSystem {
        profile = "aizeft";
        desktop = "sway";
      };
      # vm-lvm = bldr.bldSystem {
      #   profile = "vm-lvm";
      #   desktop = "sway";
      # };
      minimal = bldr.buildSystem {
        profile = "minimal";
        isIso = true;
      };
      graphical = bldr.buildSystem {
        profile = "graphical";
        isIso = true;
      };
    };

    homeManagerModules.default = ./home;

    homeConfigurations = {
      aizeft = bldr.buildHome {
        profile = "aizeft";
        desktop = "sway";
      };
      furies = bldr.buildHome {
        profile = "furies";
        desktop = "sway";
        isGeneric = true;
      };
      fates = bldr.buildHome {
        profile = "fates";
        desktop = "gnome";
        isGeneric = true;
      };
    };
  };
}
