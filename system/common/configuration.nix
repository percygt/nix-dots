{
  profile,
  lib,
  stateVersion,
  pkgs,
  useIso,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.config = {
    allowUnfree = true;
    config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  networking = {
    hostName = profile;
    useDHCP = lib.mkDefault true;
  };

  system = {
    inherit stateVersion;
    activationScripts = lib.mkIf (!useIso) {
      diff = {
        supportsDryActivation = true;
        text = ''
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
        '';
      };
    };
  };

  hardware.enableRedistributableFirmware = true;
}
