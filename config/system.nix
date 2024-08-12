{
  profile,
  lib,
  modulesPath,
  config,
  inputs,
  pkgs,
  desktop,
  ...
}:
let
  g = config._general;
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ]
    ++ [
      ./nixos-rebuild.nix
      ./home-manager.nix
      ./console.nix
      ./locale.nix
      ./nix.nix
      ./nixpkgs
      ./xremap.nix
      ./user.nix
      ./dev
      ./cli
    ]
    ++ lib.optionals (desktop != null) [
      ./apps
      ./common
      ./desktop
    ];

  home-manager.users.${g.username} = import ./home.nix;

  environment.systemPackages = (import ./corePackages.nix pkgs) ++ (with pkgs; [ rippkgs ]);

  programs = {
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    nh = {
      enable = true;
      flake = g.flakeDirectory;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 3";
      };
    };
  };

  networking = {
    hostName = profile;
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = g.stateVersion;
  swapDevices = [ ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      # Opinionated: make flake registry and nix path match flake inputs
      registry = (lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs) // {
        self.flake = inputs.self;
        n.flake = inputs.nixpkgs;
      };
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      optimise.automatic = true;
    };
}
