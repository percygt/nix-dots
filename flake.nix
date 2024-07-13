{
  description = "PercyGT's nix config";
  nixConfig = {
    extra-substituters =
      [ "https://nix-community.cachix.org" "https://percygtdev.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
    ];
  };

  inputs = {
    nix-stash.url = "github:percygt/nix-stash";
    nixpkgs.follows = "nix-stash/nixpkgs";
    nixpkgs-stable.follows = "nix-stash/nixpkgs-stable";

    swayfx-unwrapped.follows = "nix-stash/nix-sources/swayfx-unwrapped";
    neovim-nightly-overlay.follows =
      "nix-stash/nix-sources/neovim-nightly-overlay";
    emacs-overlay.follows = "nix-stash/nix-sources/emacs-overlay";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap.url = "github:xremap/nix-flake";
    xremap.inputs.nixpkgs.follows = "nixpkgs";

    nixd.url = "github:nix-community/nixd";
    nix-colors.url = "github:misterio77/nix-colors";
    impermanence.url = "github:nix-community/impermanence";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    spicetify.url = "github:the-argus/spicetify-nix";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    sikreto = {
      url = "git+ssh://git@gitlab.com/percygt/sikreto.git?ref=main&shallow=1";
      flake = false;
    };
  };
  outputs = { nixpkgs, self, ... }@inputs:
    let
      inherit (self) outputs;
      defaultUser = "percygt";
      stateVersion = "24.05";
      bldr =
        import ./lib { inherit self inputs outputs defaultUser stateVersion; };
    in {
      packages = bldr.forEachSystem (system:
        (import ./packages { pkgs = nixpkgs.legacyPackages.${system}; }));

      formatter = bldr.forEachSystem
        (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      overlays = import ./overlays { inherit inputs; };

      templates = import ./templates;

      nixosModules.default = ./modules;

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

      homeConfigurations = {
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
