{
  description = "PercyGT's nix config";

  inputs = {
    nix-stash.url = "github:percygt/nix-stash";

    nixpkgs.follows = "nix-stash/nixpkgs";
    nixpkgs-stable.follows = "nix-stash/nixpkgs-stable";

    scenefx.url = "github:wlrfx/scenefx";
    scenefx.inputs.nixpkgs.follows = "nixpkgs";
    swayfx-unwrapped = {
      url = "github:WillPower3309/swayfx";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.scenefx.follows = "scenefx";
    };

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

    xremap.url = "github:xremap/nix-flake";
    xremap.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    impermanence.url = "github:nix-community/impermanence";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nurpkgs.url = "github:nix-community/NUR";

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
      "${defaultUser}@aizeft" = bldr.buildHome {
        profile = "aizeft";
        desktop = "sway";
      };
      "${defaultUser}@furies" = bldr.buildHome {
        profile = "furies";
        desktop = "sway";
        isGeneric = true;
      };
      "${defaultUser}@fates" = bldr.buildHome {
        profile = "fates";
        desktop = "gnome";
        isGeneric = true;
      };
    };
  };
}
