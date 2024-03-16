{
  stateVersion,
  hostName,
  pkgs,
  lib,
  outputs,
  username,
  ...
}: {
  imports = [
    ./common
    ./services
  ];
  networking = {
    inherit hostName;
    useDHCP = lib.mkDefault true;
  };

  programs = {
    fish.enable = true;
  };

  services = {
    chrony.enable = true;
    journald.extraConfig = "SystemMaxUse=250M";
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      config.permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };

  # Create dirs for home-manager
  systemd.tmpfiles.rules = [
    "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root"
  ];

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
