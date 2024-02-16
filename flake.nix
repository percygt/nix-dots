{
  description = "PercyGT's nix home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-stash.url = "github:percygt/nix-stash";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs = {nixpkgs, ...} @ inputs: let
    overlays = {
      extra = final: prev:
        import ./packages {pkgs = final;};

      nodePackages-extra = final: prev: {
        nodePackages-extra = import ./packages/node {
          pkgs = prev;
          inherit (prev) system;
          nodejs = prev.nodejs_20;
        };
      };
      nix-stash = inputs.nix-stash.overlays.default;
      neovim-nightly = inputs.neovim-nightly-overlay.overlay;
    };

    forEachSystem = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
    legacyPackages = forEachSystem (
      system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
    );
    lib = import ./lib {inherit inputs;};
  in {
    inherit overlays legacyPackages;

    formatter = forEachSystem (system: legacyPackages.${system}.alejandra);

    packages = forEachSystem (system: (import ./packages {pkgs = legacyPackages.${system};}));

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
        path = ./templates/flake_parts;
        description = "A flake_parts templates with devenv integration.";
      };
    };

    homeConfigurations = {
      "home@asus-fegn" = lib.mkHomeManager {
        hostname = "asus-fegn";
        pkgs = legacyPackages.x86_64-linux;
        stateVersion = "23.11";
      };
    };
  };
}
