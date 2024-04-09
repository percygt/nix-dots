{
  profile,
  lib,
  stateVersion,
  pkgs,
  ...
}: {
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
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };
  };
}
