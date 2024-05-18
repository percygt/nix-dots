{
  profile,
  lib,
  stateVersion,
  pkgs,
  isIso,
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
