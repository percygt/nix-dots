{
  description = "PercyGT's nix home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
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
  outputs = {
    nixpkgs,
    self,
    ...
  } @ inputs: let
    nix-personal = nixpkgs.lib.optional (builtins.pathExists ./personal) ./personal;
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

      opc-nign = lib.mkNixOS rec {
        profile = "OPC-NIGN";
        system = "x86_64-linux";
        pkgs = legacyPackages.${system};
        nixosModules = [
          inputs.home-manager.nixosModules.default
        ];
        homeManagerModules = nix-personal;
      };

      opc-nihy = lib.mkNixOS rec {
        profile = "OPC-NIHY";
        system = "x86_64-linux";
        pkgs = legacyPackages.${system};
        nixosModules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.hyprland.nixosModules.default
        ];
        homeManagerModules =
          [
            inputs.hyprland.homeManagerModules.default
          ]
          ++ nix-personal;
      };
      iso = lib.mkNixOS rec {
        username = "nixos";
        profile = "ISO";
        system = "x86_64-linux";
        pkgs = legacyPackages.${system};
        nixosModules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
          inputs.home-manager.nixosModules.home-manager
          inputs.disko.nixosModules.disko
        ];
        # homeManagerModules = nix-personal;
      };
    };

    homeConfigurations = {
      asus-nihy = lib.mkHomeManager {
        profile = "ASUS-NIHY";
        pkgs = legacyPackages.x86_64-linux;
        homeManagerModules =
          nix-personal
          ++ [inputs.sops-nix.homeManagerModules.sops];
      };
      opc-nign = lib.mkhomemanager {
        profile = "OPC-NIGN";
        pkgs = legacyPackages.x86_64-linux;
        homemanagermodules = nix-personal;
      };
      opc-nihy = lib.mkhomemanager {
        profile = "OPC-NIHY";
        pkgs = legacyPackages.x86_64-linux;
        homemanagermodules = nix-personal;
      };
      "home@asus-fegn" = lib.mkHomeManager {
        profile = "ASUS-FEGN";
        pkgs = legacyPackages.x86_64-linux;
        homeManagerModules = nix-personal;
      };
    };
  };
}
