{
  stateVersion,
  hostName,
  pkgs,
  lib,
  outputs,
  username,
  modulesPath,
  desktop,
  inputs,
  ...
}: {
  imports = [
    ./common
    ./services
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.overlays =
    builtins.attrValues outputs.overlays
    ++ lib.optionals (desktop == "hyprland") [
      inputs.hypridle.overlays.default
      inputs.hyprland.overlays.default
      inputs.hyprland-contrib.overlays.default
      inputs.hyprlock.overlays.default
    ];

  nixpkgs.config = {
    allowUnfree = true;
    config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

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
