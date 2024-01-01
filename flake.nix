{
  description = "Home Manager configuration of percygt";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-23-11.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixgl";
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
    systems = inputs.flake-utils.lib.system;
  in rec {
    overlays = {
      default = import ./overlay/default.nix;
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
      neovimNightly = inputs.neovim-nightly-overlay.overlay;
      nixgl = inputs.nixgl.overlay;
    };

    formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".alejandra);
    legacyPackages = forAllSystems (
      system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
    );

    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      pkgs = legacyPackages.x86_64-linux;
      system = systems.x86_64-linux;
      extraSpecialArgs = {inherit inputs username;};
      modules = [./home.nix];
    };
  };
}
