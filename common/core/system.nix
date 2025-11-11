{
  host,
  lib,
  modulesPath,
  config,
  stateVersion,
  ...
}:
let
  g = config._global;
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  home-manager.backupFileExtension = ".backup";
  environment.systemPackages = g.system.corePackages;
  environment.variables = g.system.envVars;
  networking.hostName = host;
  networking.useDHCP = lib.mkDefault true;
  services.fwupd.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = stateVersion;
}
