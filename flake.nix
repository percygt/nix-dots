{
  description = "PercyGT's nix config";
  outputs =
    { self, ... }@inputs:
    let
      defaultUsername = "percygt";
      defaultSystem = "x86_64-linux";
      stateVersion = "25.05";
      lib = inputs.home-manager.lib // inputs.nixpkgs.lib;
      libx = import "${self}/lib/libx" { inherit lib inputs; };
      bldr = import ./lib {
        inherit
          self
          inputs
          stateVersion
          defaultSystem
          defaultUsername
          lib
          libx
          ;
      };
    in
    {
      nixosConfigurations = {
        aizeft = bldr.buildSystem {
          profile = "aizeft";
          desktop = "niri";
          extraModulesDir = [
            (toString inputs.personal)
          ];
        };
      };
      homeConfigurations = {
        "percygt@aizeft" = bldr.buildHome {
          profile = "aizeft";
          desktop = "niri";
          extraModulesDir = [
            (toString inputs.personal)
          ];
        };
      };

      nixosModules.default.imports = libx.importNixosForEachDir [ ./modules ];
      homeManagerModules.default.imports = libx.importHomeForEachDir [ ./modules ];

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
    nixpkgs-old.follows = "nix-sources/nixpkgs-old";
    nixpkgs-master.follows = "nix-sources/nixpkgs-master";
    nixpkgs-stable.follows = "nix-sources/nixpkgs-stable";
    nixpkgs-unstable.follows = "nix-sources/nixpkgs-unstable";

    niri.follows = "nix-sources/niri";
    walker.follows = "nix-stash/walker";

    doom-emacs.url = "github:doomemacs/doomemacs/master";
    doom-emacs.flake = false;

    home-manager.url = "github:nix-community/home-manager/master";
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

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/stable-v3";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    base16.url = "github:SenchoPens/base16.nix";
    nix-colorizer.url = "github:percygt/nix-colorizer";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    unf.url = "git+https://git.atagen.co/atagen/unf";
    unf.inputs.nixpkgs.follows = "nixpkgs";

    system76-scheduler-niri.url = "github:Kirottu/system76-scheduler-niri";
    system76-scheduler-niri.inputs.nixpkgs.follows = "nixpkgs";

    ironbar.url = "github:JakeStanger/ironbar";
    ironbar.inputs.nixpkgs.follows = "nixpkgs";

    personal.url = "git+ssh://git@gitlab.com/percygt/sikreto.git?ref=main&shallow=1";
    personal.flake = false;
  };
  nixConfig = {
    extra-substituters = [
      "https://percygtdev.cachix.org"
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };
}
