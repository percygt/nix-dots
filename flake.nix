{
  description = "PercyGT's nix home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-stash.url = "github:percygt/nix-stash";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    colors = (import ./lib/colors.nix).syft;
    username = "percygt";
    homeDirectory = "/home/${username}";
    flakeDirectory = "${homeDirectory}/nix-dots";
    stateVersion = "23.11";
    overlays = {
      nodePackages-extra = final: prev: {
        nodePackages-extra = import ./nixpkgs/node {
          pkgs = prev;
          inherit (prev) system;
          nodejs = prev.nodejs_20;
        };
      };
      nix-stash = inputs.nix-stash.overlays.default;
      neovim-nightly = inputs.neovim-nightly-overlay.overlay;
    };

    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    legacyPackages = forAllSystems (
      system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
    );

    formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".alejandra);
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
        path = ./templates/flake_parts;
        description = "A flake_parts templates with devenv integration.";
      };
    };
    inherit overlays legacyPackages formatter;
    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit
          inputs
          pkgs
          username
          colors
          homeDirectory
          flakeDirectory
          stateVersion
          ;
      };
      modules =
        [
          ./modules/home-manager
          ./hosts/fedora-gnome/home.nix
          ./nix-personal
        ]
        ++ nixpkgs.lib.optional (builtins.pathExists ./nix-personal) ./nix-personal;
    };
  };
}
