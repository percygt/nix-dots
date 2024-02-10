{
  description = "PercyGT's nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixgl";
    nix-stash.url = "github:percygt/nix-stash";
    nix-index-database.url = "github:Mic92/nix-index-database";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  nixConfig = {
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    colors = (import ./colors.nix).syft;
    username = "percygt";
    forAllSystems = nixpkgs.lib.genAttrs inputs.flake-utils.lib.defaultSystems;
    overlays = {
      nodePackages-extra = final: prev: {
        nodePackages-extra = import ./nixpkgs/node {
          pkgs = prev;
          inherit (prev) system;
          nodejs = prev.nodejs_20;
        };
      };
      nix-stash = inputs.nix-stash.overlays.default;
      neovimNightly = inputs.neovim-nightly-overlay.overlay;
      nixgl = inputs.nixgl.overlay;
    };
    legacyPackages = forAllSystems (
      system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
    );
    pkgs = legacyPackages.x86_64-linux;
  in {
    templates = {
      javascript = {
        path = ./templates/javascript;
        description = "A javascript Nix flake with devenv integration.";
      };
      django = {
        path = ./templates/django;
        description = "A django Nix flake with devenv integration.";
      };
      flakes_part = {
        path = ./templates/flakes_part;
        description = "A flakes.part templates with devenv integration.";
      };
    };
    inherit overlays;
    inherit legacyPackages;
    formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".alejandra);
    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs pkgs username colors;};
      modules = [./home.nix];
    };
  };
}
