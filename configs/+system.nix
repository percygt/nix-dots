{
  profile,
  lib,
  modulesPath,
  config,
  inputs,
  stateVersion,
  ...
}:
let
  g = config._base;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-cli.nixosModules.nixos-cli
    ./nixpkgs
    ./nix.nix
    ./home-manager.nix
  ];

  environment.systemPackages = g.system.corePackages;
  environment.variables.FLAKE = config.programs.nh.flake;
  programs = {
    command-not-found.enable = false;
    # nix-index.enable = true;
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

  system.stateVersion = stateVersion;
  swapDevices = [ ];
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
      # registry.nixpkgs.flake = inputs.nixpkgs;
      # nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      optimise.automatic = true;
    };
}
