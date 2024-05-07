{
  profile,
  lib,
  stateVersion,
  pkgs,
  isIso,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  programs = {
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    command-not-found.enable = false;
    bash.interactiveShellInit = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };

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
    activationScripts = lib.mkIf (!isIso) {
      diff = {
        supportsDryActivation = true;
        text = ''
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
        '';
      };
    };
  };

  hardware.enableRedistributableFirmware = true;
  # Create dirs for home-manager
  # systemd.tmpfiles.rules = ["d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root"];
}
