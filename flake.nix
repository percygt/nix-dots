{
  description = "PercyGT's nix config";
  outputs =
    { self, ... }@inputs:
    let
      defaultUsername = "percygt";
      defaultDesktop = "sway";
      defaultSystem = "x86_64-linux";
      stateVersion = "24.11";
      bldr = import ./lib {
        inherit
          self
          inputs
          stateVersion
          defaultSystem
          defaultDesktop
          defaultUsername
          ;
      };
    in
    {
      nixosConfigurations = {
        aizeft = bldr.buildSystem {
          profile = "aizeft";
        };
        minimal = bldr.buildSystem {
          profile = "minimal";
          isIso = true;
          username = "nixos";
        };
        graphical = bldr.buildSystem {
          profile = "graphical";
          isIso = true;
          username = "nixos";
        };
      };
      homeConfigurations = {
        "percygt@aizeft" = bldr.buildHome {
          profile = "aizeft";
        };
        fates = bldr.buildHome {
          profile = "fates";
          desktop = "gnome";
          isGeneric = true;
        };
      };
      nixOnDroidConfigurations.default = bldr.buildDroid { };
      nixosModules.default = ./modules;
      packages = bldr.forAllSystems (pkgs: import ./packages { inherit pkgs; });
      formatter = bldr.forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
      overlays = import ./overlays { inherit inputs; };
      templates = import ./templates;
      checks = inputs.nixpkgs.lib.genAttrs bldr.supportedSystems (
        system: import ./checks { inherit inputs system; }
      );
      devShells = inputs.nixpkgs.lib.genAttrs bldr.supportedSystems (
        system:
        import ./shell.nix {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        }
      );
    };

  inputs = {
    nix-sources.url = "github:percygt/nix-sources";
    nix-stash.url = "github:percygt/nix-stash";
    nixpkgs.follows = "nix-sources/nixpkgs";
    nixpkgs-master.follows = "nix-sources/nixpkgs-master";
    nixpkgs-stable.follows = "nix-sources/nixpkgs-stable";
    emacs-overlay.follows = "nix-sources/emacs-overlay";
    doom-emacs.url = "github:doomemacs/doomemacs/master";
    doom-emacs.flake = false;

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-cli.url = "github:water-sucks/nixos";
    nixos-cli.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    xremap.url = "github:xremap/nix-flake";
    xremap.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    nixd.url = "github:nix-community/nixd";

    impermanence.url = "github:nix-community/impermanence";

    flatpaks.url = "github:GermanBread/declarative-flatpak/stable-v3";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs = {
      nixpkgs.follows = "nixpkgs";
    };

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    base16.url = "github:SenchoPens/base16.nix";

    nur.url = "github:nix-community/NUR";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    base.url = "git+ssh://git@gitlab.com/percygt/sikreto.git?ref=main&shallow=1";
    base.flake = false;
  };
  nixConfig = {
    extra-substituters = [
      "https://percygtdev.cachix.org"
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://nix-on-droid.cachix.org"
    ];
    extra-trusted-public-keys = [
      "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
    ];
  };
}
