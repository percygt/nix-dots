{
  profile,
  lib,
  modulesPath,
  config,
  inputs,
  stateVersion,
  username,
  ...
}:
let
  g = config._base;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./nixpkgs
    ./nix.nix
    ./home-manager.nix
  ];

  home-manager.users.${username} = { };
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

  services.fwupd.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  swapDevices = [ ];
  system.stateVersion = stateVersion;
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
