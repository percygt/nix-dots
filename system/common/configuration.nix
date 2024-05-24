{
  profile,
  lib,
  stateVersion,
  modulesPath,
  flakeDirectory,
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

  nixpkgs.config = {
    allowUnfree = true;
    config.permittedInsecurePackages = ["electron-25.9.0"];
  };

  networking = {
    hostName = profile;
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = stateVersion;

  hardware.enableRedistributableFirmware = true;
}
