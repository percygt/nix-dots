{
  description = "PercyGT's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nixgl.url = "github:guibou/nixgl";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    my-nix-overlays.url = "github:percygt/nix-overlay";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    wezterm.url = "github:wez/wezterm?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    colors = (import ./colors.nix).syft;
    username = "percygt";
    forAllSystems = nixpkgs.lib.genAttrs inputs.flake-utils.lib.defaultSystems;
  in rec {
    overlays = {
      nodePackages-extra = final: prev: {
        nodePackages-extra = import ./nixpkgs/node {
          pkgs = prev;
          inherit (prev) system;
          nodejs = prev.nodejs_20;
        };
      };
      wezterm_custom = final: prev: {
        wezterm_custom = inputs.wezterm.packages."${prev.system}".default;
      };
      my-nix-overlays = inputs.my-nix-overlays.overlays.default;
      neovimNightly = inputs.neovim-nightly-overlay.overlay;
      nixgl = inputs.nixgl.overlay;
      vscode-marketplace = inputs.nix-vscode-extensions.overlays.default;
    };
    legacyPackages = forAllSystems (
      system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
    );
    templates = {
      javascript = {
        path = ./templates/javascript;
        description = "A javascript Nix flake with devenv integration.";
      };
      django = {
        path = ./templates/django;
        description = "A django Nix flake with devenv integration.";
      };
    };
    pkgs = legacyPackages.x86_64-linux;
    formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".alejandra);
    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs pkgs username colors;};
      modules = [./home.nix];
    };
  };
}
