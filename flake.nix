{
  description = "PercyGT's nix home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-stash.url = "github:percygt/nix-stash";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    # lanzaboote.url = "github:nix-community/lanzaboote";
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
    ];

    legacyPackages = forEachSystem (
      system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        }
    );

    lib = import ./lib {inherit inputs;};
  in {
    inherit overlays legacyPackages;

    formatter = forEachSystem (system: legacyPackages.${system}.alejandra);

    packages = forEachSystem (system: (import ./packages {pkgs = legacyPackages.${system};}));

    devShells = forEachSystem (system: (import ./shell.nix {
      pkgs = legacyPackages.${system};
    }));

    templates = import ./templates;

    nixosConfigurations = {
      asus-nihy = lib.mkNixOS rec {
        profile = "ASUS-NIHY";
        system = "x86_64-linux";
        pkgs = legacyPackages.${system};
      };
      opc = lib.mkNixOS rec {
        profile = "OPC";
        system = "x86_64-linux";
        pkgs = legacyPackages.${system};
      };
      iso = lib.mkNixOS rec {
        profile = "ISO";
        system = "x86_64-linux";
        pkgs = legacyPackages.${system};
        nixosModules = [
          inputs.home-manager.nixosModules.default
          inputs.hyprland.nixosModules.default
        ];
        homeManagerModules = [
          inputs.hyprland.homeManagerModules.default
        ];
      };
    };

    homeConfigurations = {
      "home@asus-fegn" = lib.mkHomeManager {
        profile = "ASUS-FEGN";
        pkgs = legacyPackages.x86_64-linux;
      };
    };
  };
}
