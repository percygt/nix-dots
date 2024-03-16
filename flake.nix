{
  description = "PercyGT's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nix-stash.url = "github:percygt/nix-stash";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

    defaultUser = "percygt";
    stateVersion = "23.11";

    libx = import ./lib {inherit self inputs defaultUser stateVersion;};
  in {
    inherit overlays legacyPackages;

    formatter = forEachSystem (system: legacyPackages.${system}.alejandra);

    packages = forEachSystem (system: (import ./packages {pkgs = legacyPackages.${system};}));

    devShells = forEachSystem (system: (import ./shell.nix {
      pkgs = legacyPackages.${system};
    }));

    templates = import ./templates;

    nixosConfigurations = {
      fates = libx.mkNixOS rec {
        profile = "fates";
        system = "x86_64-linux";
        pkgs = legacyPackages.${system};
        nixosModules = [
          inputs.home-manager.nixosModules.default
          inputs.disko.nixosModules.disko
        ];
        homeManagerModules = [inputs.hyprland.homeManagerModules.default];
      };
      vm_nixos_hypr = libx.mkNixOS rec {
        profile = "vm_nixos_hypr";
        system = "x86_64-linux";
        pkgs = legacyPackages.${system};
        nixosModules = [
          inputs.home-manager.nixosModules.default
          inputs.disko.nixosModules.disko
        ];
        homeManagerModules = [inputs.hyprland.homeManagerModules.default];
      };
      dot_iso = libx.mkNixOS rec {
        is_iso = true;
        profile = "dot_iso";
        system = "x86_64-linux";
        pkgs = legacyPackages.${system};
        nixosModules = [
          {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    };

    homeConfigurations = {
      ivlivs = libx.mkHomeManager {
        profile = "fates";
        pkgs = legacyPackages.x86_64-linux;
        homeManagerModules =
          nix-personal
          ++ [
            inputs.sops-nix.homeManagerModules.sops
          ];
      };
      vm_nixos_hypr = libx.mkHomeManager {
        profile = "vm_nixos_hypr";
        pkgs = legacyPackages.x86_64-linux;
        homeManagerModules =
          nix-personal
          ++ [
            inputs.sops-nix.homeManagerModules.sops
          ];
      };
      furies = libx.mkHomeManager {
        profile = "furies";
        is_generic_linux = true;
        is_laptop = true;
        pkgs = legacyPackages.x86_64-linux;
        homeManagerModules = nix-personal;
      };
      fates = libx.mkHomeManager {
        profile = "fates";
        is_generic_linux = true;
        pkgs = legacyPackages.x86_64-linux;
        homeManagerModules = nix-personal;
      };
    };
  };
}
