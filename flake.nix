{
  description = "PercyGT's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-23-11.url = "github:nixos/nixpkgs/nixos-23.11";

    flake-utils.url = "github:numtide/flake-utils";

    nixgl.url = "github:guibou/nixgl";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    codeium.url = "github:Exafunction/codeium.nvim";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    wezterm.url = "github:happenslol/wezterm/add-nix-flake?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    username = "percygt";
    forAllSystems = nixpkgs.lib.genAttrs inputs.flake-utils.lib.defaultSystems;
  in rec {
    overlays = {
      stable-23-11 = final: prev: {
        stable-23-11 = inputs.nixpkgs-23-11.legacyPackages.${prev.system};
      };
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
      codeium = final: prev: {
        vimPlugins =
          prev.vimPlugins
          // {
            inherit (inputs.codeium.packages."${prev.system}".vimPlugins) codeium-nvim;
          };
      };
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
    pkgs = legacyPackages.x86_64-linux;
    formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".alejandra);
    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs pkgs username;};
      modules = [./home.nix];
    };
  };
}
