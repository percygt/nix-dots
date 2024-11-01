{
  profile,
  lib,
  modulesPath,
  config,
  inputs,
  desktop,
  ...
}:
let
  g = config._general;
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.nixos-cli.nixosModules.nixos-cli
      ./core
      ./rebuild
      ./console.nix
      ./locale.nix
      ./nix.nix
      ./nixpkgs
      ./ydotool.nix
      ./xremap.nix
      ./user.nix
      ./home-manager.nix
    ]
    ++ lib.optionals (desktop != null) [
      ./fonts.nix
      ./themes.nix
    ];

  environment.systemPackages = g.system.corePackages;

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
