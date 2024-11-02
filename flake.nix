{
  description = "PercyGT's nix config";
  outputs =
    { self, ... }@inputs:
    let
      defaultUsername = "percygt";
      stateVersion = "23.05";
      bldr = import ./lib {
        inherit
          self
          inputs
          defaultUsername
          stateVersion
          ;
      };
    in
    {
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
      nixosModules.default = ./modules;
      nixosConfigurations = {
        aizeft = bldr.buildSystem {
          profile = "aizeft";
          desktop = "sway";
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
          desktop = "sway";
          username = "percygt";
        };
        # furies = bldr.buildHome {
        #   profile = "furies";
        #   desktop = "sway";
        # };
        # fates = bldr.buildHome {
        #   profile = "fates";
        #   desktop = "gnome";
        #   isGeneric = true;
        # };
      };
    };

  inputs = {
    nix-sources.url = "github:percygt/nix-sources";
    nix-stash.url = "github:percygt/nix-stash";
    nixpkgs.follows = "nix-sources/nixpkgs";
    nixpkgs-stable.follows = "nix-sources/nixpkgs-stable";
    nixpkgs-master.follows = "nix-sources/nixpkgs-master";
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

    nixd.url = "github:nix-community/nixd";

    impermanence.url = "github:nix-community/impermanence";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs = {
      nixpkgs.follows = "nixpkgs";
      nixpkgs-stable.follows = "nixpkgs-stable";
    };

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    base16.url = "github:SenchoPens/base16.nix";

    nur.url = "github:nix-community/NUR";

    tt-schemes.url = "github:tinted-theming/schemes";
    tt-schemes.flake = false;

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    general.url = "git+ssh://git@gitlab.com/percygt/sikreto.git?ref=main&shallow=1";
    general.flake = false;
  };
  nixConfig = {
    extra-substituters = [
      "https://percygtdev.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
