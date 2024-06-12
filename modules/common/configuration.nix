{
  profile,
  lib,
  stateVersion,
  modulesPath,
  flakeDirectory,
  config,
  inputs,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  programs.command-not-found.enable = false;

  programs.nh = {
    enable = true;
    flake = flakeDirectory;
    clean = {
      enable = true;
      extraArgs = "--keep-since 10d --keep 3";
    };
  };

  networking = {
    hostName = profile;
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = stateVersion;

  swapDevices = [];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mkForce (lib.mapAttrs (_: value: {flake = value;}) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mkForce (lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry);

    optimise.automatic = true;
  };
}
